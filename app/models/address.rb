class Address < ApplicationRecord
  belongs_to :user
  validates :state, :city, :country, :pincode, presence: true
  validates_length_of :pincode, is: 6, allow_blank: true
end
