class CreateUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :units do |t|
      t.decimal :monthly_rent, precision: 11, scale: 2
      t.string :unit_number
      t.boolean :vacancy
      t.integer :nbr_bedrooms
      t.integer :nbr_bathrooms
      t.decimal :annual_total, precision: 11, scale: 2

      t.timestamps
    end
  end
end
