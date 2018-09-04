class CreateUserPrivateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :user_private_messages do |t|
      t.text :content
      t.references :sender
      t.references :recipient
      t.references :event, foreign_key: true

      t.timestamps
    end

    add_foreign_key :user_private_messages, :users, column: :sender_id, primary_key: :id
    add_foreign_key :user_private_messages, :users, column: :recipient_id, primary_key: :id
  end
end
