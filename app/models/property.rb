class Property < ApplicationRecord
  has_one :address, dependent: :destroy
  has_one :expenses_record, dependent: :destroy
  has_many :units, dependent: :destroy
  has_many :quotes, dependent: :destroy

  validates :cap_rate, presence: true, numericality: { greater_than: 0, less_than: 1 }

  def noi
    total_annual_rent - total_expenses
  end

  def market_value
    noi / cap_rate
  end

  private

  def total_annual_rent
    12 * total_monthly_rent
  end

  def total_monthly_rent
    units.inject(0) {|sum, unit| sum + unit.monthly_rent}
  end

  def total_expenses
    expenses_record.total_expenses
  end
end
