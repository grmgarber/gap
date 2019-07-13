class ExpensesRecord < ApplicationRecord
  CHECKED_ATTRIBUTES = %i[marketing tax insurance repairs admin payroll utility management]

  belongs_to :property

  validates(*CHECKED_ATTRIBUTES, presence: true, numericality: { greater_than_or_equal_to: 0 })

  def total_expenses
    t.decimal :marketing, precision: 11, scale: 2
    t.decimal :tax, precision: 11, scale: 2
    t.decimal :insurance, precision: 11, scale: 2
    t.decimal :repairs, precision: 11, scale: 2
    t.decimal :admin, precision: 11, scale: 2
    t.decimal :payroll, precision: 11, scale: 2
    t.decimal :utility, precision: 11, scale: 2
    t.decimal :management, precision: 11, scale: 2

    marketing + tax + insurance + repairs + admin + payroll + utility + management
  end
end
