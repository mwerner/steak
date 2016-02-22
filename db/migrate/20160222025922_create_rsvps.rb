class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.integer :event_id, null: false
      t.string  :username
      t.boolean :attending
      t.timestamps null: false
    end

    add_index :rsvps, :event_id, unique: false
  end
end
