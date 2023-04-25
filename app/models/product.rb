class Product < ApplicationRecord
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  after_initialize :set_title, unless: :title?
  before_validation :set_discount_price, unless: :discount_price?

  validates :title, :description, :image_url, :price, :discount_price, presence: true
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, url: true
  validates :title, length: { minimum: 10 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  validates :permalink, uniqueness: true, format: { with: ::PERMALINK_REGEX }
  validates :description, format: { with: ::DESCRIPTION_REGEX }
  validates :discount_price, numericality: { less_than_or_equal_to: :price }, allow_blank: true, if: :price?

  private

  def set_discount_price
    self.discount_price = price
  end

  def set_title
    self.title = 'abc'
  end
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end
end
