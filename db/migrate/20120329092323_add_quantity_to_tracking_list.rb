class AddQuantityToTrackingList < ActiveRecord::Migration
  def change
    add_column :tracking_lists, :quantity, :integer, :default => 0

  end
end
