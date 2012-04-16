class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :desc
      t.text :image
      t.boolean :is_finished

      t.timestamps
    end
  end
end
