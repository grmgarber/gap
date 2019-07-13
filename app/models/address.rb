class Address < ApplicationRecord

  US_ZIP_REGEX = /\A\d{5}(\-\d{4})?\Z/
  USA_NAMES = ['US', 'USA', 'United States', 'United States of America']

  belongs_to :property
  validates :street, :city, :state, :postal_code, presence: true
  validates :postal_code, format: { with: US_ZIP_REGEX, message: 'Invalid US postal code' }, if: :country_usa?

  private

  def country_usa?
    ctry = country.to_s
    USA_NAMES.any? {|name| name.casecmp(ctry).zero?}
  end
end
