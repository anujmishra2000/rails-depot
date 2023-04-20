class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart, optional: true

  validates :product_id, uniqueness: { scope: :cart_id, message: 'cart cannot have multiple same product' }

  def total_price
    product.price * quantity
  end
end