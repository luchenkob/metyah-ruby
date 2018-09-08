class AddAdminToHosts < ActiveRecord::Migration[5.2]
  def change
    add_column :hosts, :admin, :boolean
  end
end
