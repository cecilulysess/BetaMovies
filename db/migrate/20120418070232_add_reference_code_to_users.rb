class AddReferenceCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reference_code, :string

  end
end
