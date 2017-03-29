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

ActiveRecord::Schema.define(:version => 20120923132833) do

  create_table "answers", :force => true do |t|
    t.string   "puzzle_id"
    t.string   "user_id"
    t.string   "content"
    t.string   "comment_cnt",        :default => "0"
    t.boolean  "is_best",            :default => false
    t.boolean  "disable",            :default => false
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
  end

  add_index "answers", ["cached_votes_down"], :name => "index_answers_on_cached_votes_down"
  add_index "answers", ["cached_votes_total"], :name => "index_answers_on_cached_votes_total"
  add_index "answers", ["cached_votes_up"], :name => "index_answers_on_cached_votes_up"

  create_table "comments", :force => true do |t|
    t.string   "answer_id"
    t.string   "user_id"
    t.string   "content"
    t.boolean  "disable",    :default => false
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "discussions", :force => true do |t|
    t.string   "puzzle_id"
    t.string   "user_id"
    t.text     "content"
    t.boolean  "disable",            :default => false
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
  end

  add_index "discussions", ["cached_votes_down"], :name => "index_discussions_on_cached_votes_down"
  add_index "discussions", ["cached_votes_total"], :name => "index_discussions_on_cached_votes_total"
  add_index "discussions", ["cached_votes_up"], :name => "index_discussions_on_cached_votes_up"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "user_id"
    t.string   "action"
    t.string   "target_type"
    t.string   "target_id"
    t.string   "contact_id"
    t.boolean  "is_viewed",   :default => false
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "providers", :force => true do |t|
    t.string   "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "url"
    t.string   "oauth_token"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "puzzles", :force => true do |t|
    t.string   "puzzle_type"
    t.string   "image"
    t.text     "lines"
    t.string   "user_id"
    t.string   "answer_cnt",      :default => "0"
    t.string   "fav_cnt",         :default => "0"
    t.string   "retweet_cnt",     :default => "0"
    t.string   "reference"
    t.string   "price"
    t.string   "desc"
    t.boolean  "has_best_answer", :default => false
    t.boolean  "disable",         :default => false
    t.boolean  "saved",           :default => false
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "relation_codes", :force => true do |t|
    t.string   "name"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "user_id"
    t.string   "content_type"
    t.string   "content"
    t.string   "reason"
    t.boolean  "close",        :default => false
    t.string   "handler"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "puzzle_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_actions", :force => true do |t|
    t.string   "user_id"
    t.string   "puzzle_id"
    t.string   "action_type"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_relations", :force => true do |t|
    t.string   "user_id"
    t.string   "contact_id"
    t.integer  "relation_code_id"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "user_stats", :force => true do |t|
    t.string   "user_id"
    t.datetime "last_login"
    t.integer  "login_cnt",          :default => 0
    t.string   "wealth",             :default => "0"
    t.string   "experience",         :default => "0"
    t.string   "medal",              :default => "0"
    t.string   "recommender",        :default => "0"
    t.string   "create_cnt",         :default => "0"
    t.string   "fav_cnt",            :default => "0"
    t.string   "retweet_cnt",        :default => "0"
    t.string   "follower_cnt",       :default => "0"
    t.string   "follow_cnt",         :default => "0"
    t.string   "reported_cnt",       :default => "0"
    t.string   "answer_cnt",         :default => "0"
    t.string   "correct_answer_cnt", :default => "0"
    t.string   "viewed_cnt",         :default => "0"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "avatar"
    t.integer  "gender",                 :default => -1
    t.string   "password"
    t.string   "password_salt"
    t.string   "email"
    t.string   "domain"
    t.string   "brief"
    t.integer  "location_id"
    t.boolean  "from_provider",          :default => false
    t.boolean  "disable",                :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "extra1"
    t.string   "extra2"
    t.string   "extra3"
    t.string   "extra4"
    t.string   "extra5"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "douban_link"
    t.string   "weibo_name"
    t.string   "name_filter"
  end

  add_index "users", ["name_filter"], :name => "index_users_on_name_filter"

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
