class AddReferences < ActiveRecord::Migration[5.2]
  def change
      add_column :expenses_records, :property_id, :reference
      add_column :units, :property_id, :reference
  end
end
