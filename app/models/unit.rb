class Unit < ApplicationRecord
  MY_ATTRIBUTES = %i[monthly_rent unit_number nbr_bedrooms nbr_bathrooms vacancy annual_total]

  belongs_to :property

  validates :monthly_rent, presence: true, numericality: {greater_than: 0}
  validates :unit_number, presence: true
  validates :nbr_bedrooms, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :nbr_bathrooms, presence: true, numericality: {only_integer: true, greater_than: 0}
end
