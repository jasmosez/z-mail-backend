class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :google_id
      t.string :name
      t.belongs_to :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
