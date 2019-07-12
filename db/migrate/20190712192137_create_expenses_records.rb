class CreateExpensesRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses_records do |t|
      t.decimal :marketing, precision: 11, scale: 2
      t.decimal :tax, precision: 11, scale: 2
      t.decimal :insurance, precision: 11, scale: 2
      t.decimal :repairs, precision: 11, scale: 2
      t.decimal :admin, precision: 11, scale: 2
      t.decimal :payroll, precision: 11, scale: 2
      t.decimal :utility, precision: 11, scale: 2
      t.decimal :management, precision: 11, scale: 2

      t.timestamps
    end
  end
end
