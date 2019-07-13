class FixProperyReferences < ActiveRecord::Migration[5.2]
  def change
    change_column :addresses, :property_id, :integer
    change_column :expenses_records, :property_id, :integer
    change_column :units, :property_id, :integer
  end
end
