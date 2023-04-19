class Product < ApplicationRecord
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  #...

  validates :title, :description, :image_url, presence: true
# 
  validates :title, uniqueness: true

  # Validate image_url format by using url:true
  validates :image_url, allow_blank: true, url: true 

  validates :title, length: {minimum: 10}

  #Price numericality validation should only run if price is present.
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, if: :price?

  # Permalink must be unique and no special character and no space allowed and minimum 3 words, separated by hyphen
  validates :permalink, uniqueness: true, format: { with: PERMALINK_REGEX}

  # Description - should be between 5 and 10 words
  validates :description, format: { with: DESCRIPTION_REGEX}

  #using custom validator
  validate :price_should_be_greater_than_discount_price

  #without custom validator
  validates :price, numericality: { greater_than: :discount_price }, if: :discount_price?

  private
  
  def price_should_be_greater_than_discount_price
    if price < discount_price
      errors.add(:price, "can't be less than #{discount_price}")
    end
  end

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end
end
