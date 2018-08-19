class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :place, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.string :start_end_at
      t.string :name
      t.string :address
      t.text :description
      t.string :code
      t.string :event_status
      t.string :event_type
      t.integer :display_profiles_after_minutes
      t.integer :display_profiles_for_minutes
      t.integer :allow_messaging_after_minutes
      t.integer :allow_messaging_for_minutes

      t.timestamps
    end

    add_index :events, :code, unique: true
  end
end
