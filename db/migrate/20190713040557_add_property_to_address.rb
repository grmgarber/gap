class AddPropertyToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :property_id, :reference
  end
end
