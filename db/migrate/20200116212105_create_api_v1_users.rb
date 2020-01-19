class CreateApiV1Users < ActiveRecord::Migration[6.0]
  def change
    create_table :api_v1_users do |t|
      t.string :email
      t.string :google_token
      t.string :google_refresh_token

      t.timestamps
    end
  end
end
