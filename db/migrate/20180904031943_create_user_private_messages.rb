class CreateUserPrivateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :user_private_messages do |t|
      t.text :content
      t.references :sender, foreign_key: true
      t.references :recipient, foreign_key: true

      t.timestamps
    end
  end
end
