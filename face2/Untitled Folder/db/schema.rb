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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150623100715) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "activity_inboxes", force: true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_inboxes", ["activity_id"], name: "index_activity_inboxes_on_activity_id", using: :btree
  add_index "activity_inboxes", ["user_id", "activity_id"], name: "index_activity_inboxes_on_user_id_and_activity_id", unique: true, using: :btree
  add_index "activity_inboxes", ["user_id"], name: "index_activity_inboxes_on_user_id", using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "app_driver_histories", force: true do |t|
    t.string   "identifier"
    t.string   "achieve_id"
    t.datetime "accepted_time"
    t.integer  "campaign_id"
    t.string   "campaign_name"
    t.integer  "advertisement_id"
    t.string   "advertisement_name"
    t.integer  "point"
    t.string   "payment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "increase_ticket"
    t.text     "device_id"
  end

  add_index "app_driver_histories", ["identifier", "advertisement_id"], name: "index_app_driver_histories_on_identifier_and_advertisement_id", using: :btree
  add_index "app_driver_histories", ["user_id"], name: "index_app_driver_histories_on_user_id", using: :btree

  create_table "bans", force: true do |t|
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reportable_id"
    t.string   "reportable_type"
  end

  add_index "bans", ["deleted_at"], name: "index_bans_on_deleted_at", using: :btree
  add_index "bans", ["reportable_id", "reportable_type"], name: "index_bans_on_reportable_id_and_reportable_type", using: :btree
  add_index "bans", ["user_id"], name: "index_bans_on_user_id", using: :btree

  create_table "bulletins", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cameras", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "followerships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followerships", ["followee_id"], name: "index_followerships_on_followee_id", using: :btree
  add_index "followerships", ["follower_id", "followee_id"], name: "index_followerships_on_follower_id_and_followee_id", unique: true, using: :btree
  add_index "followerships", ["follower_id"], name: "index_followerships_on_follower_id", using: :btree

  create_table "m_activity_templates", force: true do |t|
    t.string   "key"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "m_genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "m_ranking_types", force: true do |t|
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "m_versions", force: true do |t|
    t.string   "required_ios"
    t.string   "required_android"
    t.string   "latest_ios"
    t.string   "latest_android"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "os", force: true do |t|
    t.integer  "user_id"
    t.string   "device_token"
    t.string   "registration_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "os", ["user_id"], name: "index_os_on_user_id", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "post_id"
    t.string   "content"
    t.text     "description"
    t.boolean  "main"
    t.datetime "deleted_at"
    t.integer  "width_ratio"
    t.integer  "height_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["deleted_at"], name: "index_photos_on_deleted_at", using: :btree
  add_index "photos", ["main"], name: "index_photos_on_main", using: :btree
  add_index "photos", ["post_id"], name: "index_photos_on_post_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "m_genre_id"
    t.integer  "supporters_count", default: 0,     null: false
    t.integer  "comments_count",   default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "download",         default: false
    t.integer  "camera_id"
    t.string   "location"
    t.integer  "photographer_id"
  end

  add_index "posts", ["comments_count"], name: "index_posts_on_comments_count", using: :btree
  add_index "posts", ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree
  add_index "posts", ["m_genre_id"], name: "index_posts_on_m_genre_id", using: :btree
  add_index "posts", ["supporters_count"], name: "index_posts_on_supporters_count", using: :btree
  add_index "posts", ["updated_at"], name: "index_posts_on_updated_at", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "posts_tags", id: false, force: true do |t|
    t.integer "post_id", null: false
    t.integer "tag_id",  null: false
  end

  add_index "posts_tags", ["post_id"], name: "index_posts_tags_on_post_id", using: :btree
  add_index "posts_tags", ["tag_id"], name: "index_posts_tags_on_tag_id", using: :btree

  create_table "ranking_histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "daily_1",       default: 0, null: false
    t.integer  "daily_2",       default: 0, null: false
    t.integer  "daily_3",       default: 0, null: false
    t.integer  "monthly_1_3",   default: 0, null: false
    t.integer  "monthly_4_10",  default: 0, null: false
    t.integer  "monthly_11_50", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranking_histories", ["user_id"], name: "index_ranking_histories_on_user_id", using: :btree

  create_table "rankings", force: true do |t|
    t.string   "type"
    t.datetime "starts_displaying_at"
    t.datetime "ends_displaying_at"
    t.integer  "m_ranking_type_id"
    t.integer  "m_genre_id"
    t.string   "top_ranker_name"
    t.string   "range"
    t.text     "ranker_photos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rankings", ["ends_displaying_at"], name: "index_rankings_on_ends_displaying_at", using: :btree
  add_index "rankings", ["m_genre_id"], name: "index_rankings_on_m_genre_id", using: :btree
  add_index "rankings", ["m_ranking_type_id"], name: "index_rankings_on_m_ranking_type_id", using: :btree
  add_index "rankings", ["type"], name: "index_rankings_on_type", using: :btree

  create_table "request_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "request_tokens", ["user_id"], name: "index_request_tokens_on_user_id", using: :btree

  create_table "rpush_apps", force: true do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                              default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                             default: 86400
    t.boolean  "delivered",                          default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                             default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                      default: false
    t.string   "type",                                                   null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                   default: false,     null: false
    t.text     "registration_ids",  limit: 16777215
    t.integer  "app_id",                                                 null: false
    t.integer  "retries",                            default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                         default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["app_id", "delivered", "failed", "deliver_after"], name: "index_rapns_notifications_multi", using: :btree
  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", using: :btree

  create_table "subtotals", force: true do |t|
    t.string   "type"
    t.integer  "ranking_id"
    t.integer  "user_id"
    t.integer  "rank"
    t.integer  "supporters_count"
    t.integer  "supportings_count"
    t.text     "supporter_photos"
    t.datetime "targeted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subtotals", ["rank"], name: "index_subtotals_on_rank", using: :btree
  add_index "subtotals", ["ranking_id"], name: "index_subtotals_on_ranking_id", using: :btree
  add_index "subtotals", ["targeted_at"], name: "index_subtotals_on_targeted_at", using: :btree
  add_index "subtotals", ["type"], name: "index_subtotals_on_type", using: :btree
  add_index "subtotals", ["user_id"], name: "index_subtotals_on_user_id", using: :btree

  create_table "supporterships", force: true do |t|
    t.integer  "post_id"
    t.integer  "supporter_id"
    t.integer  "supportee_id"
    t.integer  "m_genre_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supporterships", ["deleted_at"], name: "index_supporterships_on_deleted_at", using: :btree
  add_index "supporterships", ["m_genre_id"], name: "index_supporterships_on_m_genre_id", using: :btree
  add_index "supporterships", ["post_id"], name: "index_supporterships_on_post_id", using: :btree
  add_index "supporterships", ["supportee_id"], name: "index_supporterships_on_supportee_id", using: :btree
  add_index "supporterships", ["supporter_id"], name: "index_supporterships_on_supporter_id", using: :btree
  add_index "supporterships", ["updated_at"], name: "index_supporterships_on_updated_at", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.integer  "user_id"
    t.integer  "max_count"
    t.integer  "over_count"
    t.integer  "recover_time"
    t.datetime "recovers_all_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "login_id"
    t.string   "facebook_id"
    t.string   "profile_photo"
    t.text     "facebook_token"
    t.string   "email"
    t.string   "password_digest"
    t.date     "birthday"
    t.datetime "deleted_at"
    t.integer  "followers_count",       default: 0,    null: false
    t.integer  "followings_count",      default: 0,    null: false
    t.integer  "supportings_count",     default: 0,    null: false
    t.integer  "posts_count",           default: 0,    null: false
    t.boolean  "ticket_recover_notice", default: true
    t.boolean  "no_login_notice",       default: true
    t.boolean  "followee_posts_notice", default: true
    t.boolean  "supported_notice",      default: true
    t.boolean  "commented_notice",      default: true
    t.boolean  "followed_notice",       default: true
    t.boolean  "bulletin_notice",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.string   "facebook_name"
    t.string   "google_id"
    t.string   "twitter_id"
    t.text     "google_token"
    t.text     "twitter_token"
    t.string   "remember_token"
    t.boolean  "only_photographer"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_name"], name: "index_users_on_facebook_name", using: :btree
  add_index "users", ["google_id"], name: "index_users_on_google_id", using: :btree
  add_index "users", ["posts_count"], name: "index_users_on_posts_count", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["twitter_id"], name: "index_users_on_twitter_id", using: :btree

end
