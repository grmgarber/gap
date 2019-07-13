class ExpensesRecord < ApplicationRecord
  CHECKED_ATTRIBUTES = %i[marketing tax insurance repairs admin payroll utility management]

  belongs_to :property

  validates(*CHECKED_ATTRIBUTES, presence: true, numericality: { greater_than_or_equal_to: 0 })

  def total_expenses
    marketing + tax + insurance + repairs + admin + payroll + utility + management
  end
end
