class CreateTrackingItems < ActiveRecord::Migration
  def change
    create_table :tracking_items do |t|
      t.integer :movie_id
      t.integer :tracking_list_id

      t.timestamps
    end
  end
end
