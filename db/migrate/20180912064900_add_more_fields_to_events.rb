class AddMoreFieldsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :ticket_purchase_url, :string
    add_column :events, :contact_info, :text
  end
end
