class Address < ApplicationRecord

  belongs_to :property
  validates :street, :city, :state, :postal_code, presence: true

end
