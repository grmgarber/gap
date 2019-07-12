class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.float :cap_rate

      t.timestamps
    end
  end
end
