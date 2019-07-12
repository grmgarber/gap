class Property < ApplicationRecord
  has_one :address
  has_one :expenses_record
  has_many :units
  has_many :quotes
end
