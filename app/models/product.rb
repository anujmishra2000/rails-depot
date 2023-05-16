class Product < ApplicationRecord
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items
  has_many :carts, through: :line_items
  has_many_attached :images, dependent: :destroy
  belongs_to :category

  validates :title, :description, :image_url, :price, :discount_price, presence: true
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, url: true
  validates :title, length: { minimum: 10 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  validates :permalink, uniqueness: true, format: { with: ::PERMALINK_REGEX }
  validates :description, format: { with: ::DESCRIPTION_REGEX }
  validates :discount_price, numericality: { less_than_or_equal_to: :price }, allow_blank: true, if: :price?
  validates_length_of :images, in: 1..3, too_short: 'must have atleast one image', too_long: 'cannot have more than 3 images'

  after_initialize :set_title, unless: :title?
  before_validation :set_discount_price, unless: :discount_price?
  after_save_commit :set_count_on_save
  after_destroy_commit :set_count_on_destroy

  scope :enabled, -> { where(enabled: true) }
  scope :ordered_atleast_once, -> { joins(:line_items).distinct }
  scope :title_for_ordered_atleast_once, -> { ordered_atleast_once.pluck(:title) }

  private

  def set_count_on_save
    unless category_id_before_last_save.nil?
      Category.find(category_id_before_last_save).update_products_count
    end
    category.update_products_count
  end

  def set_count_on_destroy
    category.update_products_count
  end

  def set_discount_price
    self.discount_price = price
  end

  def set_title
    self.title = 'abc'
  end
end
