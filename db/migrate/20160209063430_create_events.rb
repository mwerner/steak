class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :key, null: false
      t.string :name
      t.string :body
      t.string :location
      t.string :image_url
      t.string :notes, array: true, default: []
      t.datetime :occurs_at
      t.timestamps null: false
    end

    add_index :events, :key, unique: true
  end
end
