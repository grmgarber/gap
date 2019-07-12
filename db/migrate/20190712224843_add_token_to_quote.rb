class AddTokenToQuote < ActiveRecord::Migration[5.2]
  def change
    add_column :quotes, :token, :string
  end
end
