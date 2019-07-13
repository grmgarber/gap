class ExpensesRecord < ApplicationRecord
  belongs_to :property

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
