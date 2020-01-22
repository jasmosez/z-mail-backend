class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :token, null: false, foreign_key: true
      t.datetime :date
      t.string :google_id
      t.string :subject
      t.string :from
      t.string :snippet

      t.timestamps
    end
  end
end
