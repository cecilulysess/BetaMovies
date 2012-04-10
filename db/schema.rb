# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120410112022) do

  create_table "episodes", :force => true do |t|
    t.string   "episode_title"
    t.string   "link"
    t.integer  "movie_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "episodes", ["movie_id"], :name => "index_episodes_on_movie_id"

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.date     "last_updated"
    t.boolean  "is_finished"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tracking_items", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "tracking_list_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "last_watched_episode_id"
  end

  create_table "tracking_lists", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "quantity",   :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "privilege",       :default => 0, :null => false
  end

end
