class CreateQuotes < ActiveRecord::Migration[5.2]
  def change
    create_table :quotes do |t|
      t.references :property
      t.decimal :ref_rate, precision: 4, scale: 2
      t.timestamps
    end
  end
end
