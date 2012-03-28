class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.date :last_updated
      t.boolean :is_finished

      t.timestamps
    end
  end
end
