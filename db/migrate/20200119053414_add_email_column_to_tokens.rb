class AddEmailColumnToTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :email, :string
  end
end
