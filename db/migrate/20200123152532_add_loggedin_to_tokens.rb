class AddLoggedinToTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :loggedin, :boolean
  end
end
