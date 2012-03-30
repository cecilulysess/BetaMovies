class AddLastWatchedEpisodeIdToTrackingItem < ActiveRecord::Migration
  def change
    add_column :tracking_items, :last_watched_episode_id, :integer

  end
end
