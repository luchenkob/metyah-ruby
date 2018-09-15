class AddMessageReadToUserPrivateMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :user_private_messages, :message_read, :boolean
  end
end
