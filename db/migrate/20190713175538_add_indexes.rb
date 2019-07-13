class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :addresses, :property_id
    add_index :expenses_records, :property_id
    add_index :units, :property_id
  end
end
