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

ActiveRecord::Schema.define(:version => 20130725025927) do

  create_table "affiliate_clicks", :force => true do |t|
    t.integer  "clicks",                :default => 1
    t.string   "ip"
    t.string   "user_agent"
    t.string   "tracking_code"
    t.integer  "user_id"
    t.integer  "affiliate_tracking_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "affiliate_clicks", ["affiliate_tracking_id"], :name => "index_affiliate_clicks_on_affiliate_tracking_id"
  add_index "affiliate_clicks", ["user_id"], :name => "index_affiliate_clicks_on_user_id"

  create_table "affiliate_sales", :force => true do |t|
    t.boolean  "completed",             :default => false
    t.integer  "user_id"
    t.integer  "order_id"
    t.integer  "affiliate_tracking_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "affiliate_sales", ["affiliate_tracking_id"], :name => "index_affiliate_sales_on_affiliate_tracking_id"
  add_index "affiliate_sales", ["order_id"], :name => "index_affiliate_sales_on_order_id"
  add_index "affiliate_sales", ["user_id"], :name => "index_affiliate_sales_on_user_id"

  create_table "affiliate_trackings", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "note"
    t.string   "affiliate_tag"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "affiliate_trackings", ["user_id"], :name => "index_affiliate_trackings_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "checkins", :force => true do |t|
    t.integer  "goal_user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "checkins", ["goal_user_id"], :name => "index_checkins_on_goal_user_id"

  create_table "cms_blocks", :force => true do |t|
    t.integer  "page_id",                        :null => false
    t.string   "identifier",                     :null => false
    t.text     "content",    :limit => 16777215
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "cms_blocks", ["page_id", "identifier"], :name => "index_cms_blocks_on_page_id_and_identifier"

  create_table "cms_categories", :force => true do |t|
    t.integer "site_id",          :null => false
    t.string  "label",            :null => false
    t.string  "categorized_type", :null => false
  end

  add_index "cms_categories", ["site_id", "categorized_type", "label"], :name => "index_cms_categories_on_site_id_and_categorized_type_and_label", :unique => true

  create_table "cms_categorizations", :force => true do |t|
    t.integer "category_id",      :null => false
    t.string  "categorized_type", :null => false
    t.integer "categorized_id",   :null => false
  end

  add_index "cms_categorizations", ["category_id", "categorized_type", "categorized_id"], :name => "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", :unique => true

  create_table "cms_files", :force => true do |t|
    t.integer  "site_id",                                          :null => false
    t.integer  "block_id"
    t.string   "label",                                            :null => false
    t.string   "file_file_name",                                   :null => false
    t.string   "file_content_type",                                :null => false
    t.integer  "file_file_size",                                   :null => false
    t.string   "description",       :limit => 2048
    t.integer  "position",                          :default => 0, :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "cms_files", ["site_id", "block_id"], :name => "index_cms_files_on_site_id_and_block_id"
  add_index "cms_files", ["site_id", "file_file_name"], :name => "index_cms_files_on_site_id_and_file_file_name"
  add_index "cms_files", ["site_id", "label"], :name => "index_cms_files_on_site_id_and_label"
  add_index "cms_files", ["site_id", "position"], :name => "index_cms_files_on_site_id_and_position"

  create_table "cms_layouts", :force => true do |t|
    t.integer  "site_id",                                           :null => false
    t.integer  "parent_id"
    t.string   "app_layout"
    t.string   "label",                                             :null => false
    t.string   "identifier",                                        :null => false
    t.text     "content",    :limit => 16777215
    t.text     "css",        :limit => 16777215
    t.text     "js",         :limit => 16777215
    t.integer  "position",                       :default => 0,     :null => false
    t.boolean  "is_shared",                      :default => false, :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "cms_layouts", ["parent_id", "position"], :name => "index_cms_layouts_on_parent_id_and_position"
  add_index "cms_layouts", ["site_id", "identifier"], :name => "index_cms_layouts_on_site_id_and_identifier", :unique => true

  create_table "cms_pages", :force => true do |t|
    t.integer  "site_id",                                               :null => false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",                                                 :null => false
    t.string   "slug"
    t.string   "full_path",                                             :null => false
    t.text     "content",        :limit => 16777215
    t.integer  "position",                           :default => 0,     :null => false
    t.integer  "children_count",                     :default => 0,     :null => false
    t.boolean  "is_published",                       :default => true,  :null => false
    t.boolean  "is_shared",                          :default => false, :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "cms_pages", ["parent_id", "position"], :name => "index_cms_pages_on_parent_id_and_position"
  add_index "cms_pages", ["site_id", "full_path"], :name => "index_cms_pages_on_site_id_and_full_path"

  create_table "cms_revisions", :force => true do |t|
    t.string   "record_type",                     :null => false
    t.integer  "record_id",                       :null => false
    t.text     "data",        :limit => 16777215
    t.datetime "created_at"
  end

  add_index "cms_revisions", ["record_type", "record_id", "created_at"], :name => "index_cms_revisions_on_rtype_and_rid_and_created_at"

  create_table "cms_sites", :force => true do |t|
    t.string  "label",                          :null => false
    t.string  "identifier",                     :null => false
    t.string  "hostname",                       :null => false
    t.string  "path"
    t.string  "locale",      :default => "en",  :null => false
    t.boolean "is_mirrored", :default => false, :null => false
  end

  add_index "cms_sites", ["hostname"], :name => "index_cms_sites_on_hostname"
  add_index "cms_sites", ["is_mirrored"], :name => "index_cms_sites_on_is_mirrored"

  create_table "cms_snippets", :force => true do |t|
    t.integer  "site_id",                                           :null => false
    t.string   "label",                                             :null => false
    t.string   "identifier",                                        :null => false
    t.text     "content",    :limit => 16777215
    t.integer  "position",                       :default => 0,     :null => false
    t.boolean  "is_shared",                      :default => false, :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "cms_snippets", ["site_id", "identifier"], :name => "index_cms_snippets_on_site_id_and_identifier", :unique => true
  add_index "cms_snippets", ["site_id", "position"], :name => "index_cms_snippets_on_site_id_and_position"

  create_table "course_users", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "course_users", ["course_id"], :name => "index_course_users_on_course_id"
  add_index "course_users", ["user_id"], :name => "index_course_users_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "cost"
    t.integer  "owner_id"
    t.integer  "review_positive",                                          :default => 0
    t.integer  "review_negative",                                          :default => 0
    t.boolean  "hidden",                                                   :default => false
    t.text     "google_conversion_tracking"
    t.decimal  "affiliate_commission",       :precision => 6, :scale => 3, :default => 50.0
    t.integer  "default_market_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

  add_index "courses", ["default_market_id"], :name => "index_courses_on_default_market_id"
  add_index "courses", ["owner_id"], :name => "index_courses_on_owner_id"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "goal_users", :force => true do |t|
    t.boolean  "private",    :default => true
    t.integer  "user_id"
    t.integer  "goal_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "goal_users", ["goal_id"], :name => "index_goal_users_on_goal_id"
  add_index "goal_users", ["user_id"], :name => "index_goal_users_on_user_id"

  create_table "goals", :force => true do |t|
    t.string   "name"
    t.boolean  "hidden",              :default => false
    t.boolean  "welcome",             :default => false
    t.integer  "ordering",            :default => 9999
    t.integer  "user_count"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "category_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "goals", ["category_id"], :name => "index_goals_on_category_id"

  create_table "identities", :force => true do |t|
    t.text     "access_token"
    t.string   "uid"
    t.string   "provider"
    t.string   "identifier"
    t.integer  "owner_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "identities", ["owner_id"], :name => "index_identities_on_owner_id"

  create_table "lectures", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.integer  "section_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lectures", ["section_id"], :name => "index_lectures_on_section_id"

  create_table "markets", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "affiliate_tag"
    t.text     "content"
    t.boolean  "hidden",              :default => false
    t.boolean  "slider",              :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "course_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "markets", ["course_id"], :name => "index_markets_on_course_id"

  create_table "orders", :force => true do |t|
    t.string   "transaction_id"
    t.string   "transaction_status"
    t.text     "ipn"
    t.integer  "status"
    t.string   "subscriber_id"
    t.integer  "cost"
    t.integer  "course_id",          :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "orders", ["course_id"], :name => "index_orders_on_course_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "payloads", :force => true do |t|
    t.string   "payload_file_name"
    t.string   "payload_content_type"
    t.integer  "payload_file_size"
    t.datetime "payload_updated_at"
    t.integer  "intended_type"
    t.integer  "payloadable_id"
    t.string   "payloadable_type"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "poll_choices", :force => true do |t|
    t.string   "name"
    t.integer  "poll_question_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "poll_choices", ["poll_question_id"], :name => "index_poll_choices_on_poll_question_id"

  create_table "poll_questions", :force => true do |t|
    t.string   "name"
    t.boolean  "display_results", :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "poll_results", :force => true do |t|
    t.integer  "poll_question_id"
    t.integer  "poll_choice_id"
    t.integer  "owner_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "poll_results", ["owner_id"], :name => "index_poll_results_on_owner_id"
  add_index "poll_results", ["poll_choice_id"], :name => "index_poll_results_on_poll_choice_id"
  add_index "poll_results", ["poll_question_id"], :name => "index_poll_results_on_poll_question_id"

  create_table "reviews", :force => true do |t|
    t.text     "content"
    t.boolean  "recommended", :default => true
    t.integer  "owner_id"
    t.integer  "course_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "reviews", ["course_id"], :name => "index_reviews_on_course_id"
  add_index "reviews", ["owner_id"], :name => "index_reviews_on_owner_id"

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sections", ["course_id"], :name => "index_sections_on_course_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.boolean  "has_password",                                               :default => true
    t.datetime "identity_unlocked_at",                                       :default => '1970-01-01 01:01:00', :null => false
    t.text     "about"
    t.text     "instructor_about"
    t.text     "notes"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.string   "timezone",                                                   :default => "Etc/Zulu"
    t.string   "tagline",                                                    :default => ""
    t.decimal  "survey_base",                  :precision => 6, :scale => 3, :default => 0.0
    t.decimal  "checkin_base",                 :precision => 6, :scale => 3, :default => 0.0
    t.boolean  "auto_follow",                                                :default => false
    t.string   "affiliate_tag"
    t.integer  "affiliate_default_payment_id"
    t.integer  "affiliate_payment_frequency"
    t.boolean  "access_normal",                                              :default => true
    t.boolean  "access_affiliate",                                           :default => false
    t.boolean  "access_instructor",                                          :default => false
    t.boolean  "access_support",                                             :default => false
    t.boolean  "access_admin",                                               :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email",                                                      :default => "",                    :null => false
    t.string   "encrypted_password",                                         :default => "",                    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "goal_count",                                                 :default => 0
    t.integer  "course_count",                                               :default => 0
    t.datetime "created_at",                                                                                    :null => false
    t.datetime "updated_at",                                                                                    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
