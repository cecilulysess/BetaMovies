class AddPrivilegeToUser < ActiveRecord::Migration
  def change
    add_column :users, :privilege, :integer, :null => false, :default => 0

  end
end
