class AddProfileFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :gender, :string
    add_column :users, :career, :string
    add_column :users, :school, :string
    add_column :users, :location, :string
    add_column :users, :bio, :string
  end
end
