class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart, optional: true
  #Combination of product_id and cart_id should be unique. Means one product can be added only once in the cart. If cart with cart_id exists.
  validates :cart_id, uniqueness: { scope: :product_id, message: 'cart cannot have multiple same product'}
  def total_price
    product.price * quantity
  end
    
end
