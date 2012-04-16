class AddMovieForeignKeys < ActiveRecord::Migration
  def up
    add_column :episodes, :movie_id, :integer
  end

  def down
    remove_column :episodes, :movie_id
  end
end
