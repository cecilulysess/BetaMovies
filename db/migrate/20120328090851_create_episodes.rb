class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :episode_title
      t.string :link
      t.references :movie

      t.timestamps
    end
    add_index :episodes, :movie_id
  end
end
