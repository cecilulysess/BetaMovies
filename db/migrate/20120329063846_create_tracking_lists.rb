class CreateTrackingLists < ActiveRecord::Migration
  def change
    create_table :tracking_lists do |t|

      t.timestamps
    end
  end
end
