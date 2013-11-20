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

ActiveRecord::Schema.define(version: 20131120084846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.boolean  "read",           default: false
    t.integer  "count",          default: 1
    t.string   "share_key"
    t.string   "action"
    t.text     "parameters"
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "affiliate_clicks", force: true do |t|
    t.integer  "clicks",            default: 1
    t.string   "ip"
    t.string   "user_agent"
    t.string   "tracking_code"
    t.integer  "user_id"
    t.integer  "affiliate_link_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "affiliate_clicks", ["affiliate_link_id"], name: "index_affiliate_clicks_on_affiliate_tracking_id", using: :btree
  add_index "affiliate_clicks", ["user_id"], name: "index_affiliate_clicks_on_user_id", using: :btree

  create_table "affiliate_links", force: true do |t|
    t.string   "slug"
    t.string   "market_tag"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "note"
    t.string   "name"
  end

  add_index "affiliate_links", ["slug"], name: "index_affiliate_links_on_slug", unique: true, using: :btree

  create_table "affiliate_sales", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.integer  "affiliate_link_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "completed",         default: false
  end

  add_index "affiliate_sales", ["affiliate_link_id"], name: "index_affiliate_sales_on_affiliate_link_id", using: :btree
  add_index "affiliate_sales", ["order_id"], name: "index_affiliate_sales_on_order_id", using: :btree
  add_index "affiliate_sales", ["user_id"], name: "index_affiliate_sales_on_user_id", using: :btree

  create_table "article_authors", force: true do |t|
    t.integer  "author_id"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "article_authors", ["article_id"], name: "index_article_authors_on_article_id", using: :btree
  add_index "article_authors", ["author_id"], name: "index_article_authors_on_author_id", using: :btree

  create_table "article_courses", force: true do |t|
    t.integer  "sequence"
    t.integer  "article_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "article_courses", ["article_id"], name: "index_article_courses_on_article_id", using: :btree
  add_index "article_courses", ["course_id"], name: "index_article_courses_on_course_id", using: :btree

  create_table "article_volumes", force: true do |t|
    t.integer  "article_source_id"
    t.integer  "article_target_id"
    t.integer  "sequence"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "article_volumes", ["article_source_id"], name: "index_article_volumes_on_article_source_id", using: :btree
  add_index "article_volumes", ["article_target_id"], name: "index_article_volumes_on_article_target_id", using: :btree

  create_table "articles", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.boolean  "hidden"
    t.integer  "category_id"
    t.integer  "course_id"
    t.integer  "goal_id"
    t.integer  "default_market_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
  add_index "articles", ["course_id"], name: "index_articles_on_course_id", using: :btree
  add_index "articles", ["default_market_id"], name: "index_articles_on_default_market_id", using: :btree
  add_index "articles", ["goal_id"], name: "index_articles_on_goal_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "checkins", force: true do |t|
    t.integer  "goal_user_id"
    t.text     "thoughts"
    t.integer  "up_votes",     default: 0
    t.integer  "down_votes",   default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "checkins", ["goal_user_id"], name: "index_checkins_on_goal_user_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "cms_blocks", force: true do |t|
    t.integer  "page_id",    null: false
    t.string   "identifier", null: false
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cms_blocks", ["page_id", "identifier"], name: "index_cms_blocks_on_page_id_and_identifier", using: :btree

  create_table "cms_categories", force: true do |t|
    t.integer "site_id",          null: false
    t.string  "label",            null: false
    t.string  "categorized_type", null: false
  end

  add_index "cms_categories", ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_categorized_type_and_label", unique: true, using: :btree

  create_table "cms_categorizations", force: true do |t|
    t.integer "category_id",      null: false
    t.string  "categorized_type", null: false
    t.integer "categorized_id",   null: false
  end

  add_index "cms_categorizations", ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree

  create_table "cms_files", force: true do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "block_id"
    t.string   "label",                                      null: false
    t.string   "file_file_name",                             null: false
    t.string   "file_content_type",                          null: false
    t.integer  "file_file_size",                             null: false
    t.string   "description",       limit: 2048
    t.integer  "position",                       default: 0, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "cms_files", ["site_id", "block_id"], name: "index_cms_files_on_site_id_and_block_id", using: :btree
  add_index "cms_files", ["site_id", "file_file_name"], name: "index_cms_files_on_site_id_and_file_file_name", using: :btree
  add_index "cms_files", ["site_id", "label"], name: "index_cms_files_on_site_id_and_label", using: :btree
  add_index "cms_files", ["site_id", "position"], name: "index_cms_files_on_site_id_and_position", using: :btree

  create_table "cms_layouts", force: true do |t|
    t.integer  "site_id",                    null: false
    t.integer  "parent_id"
    t.string   "app_layout"
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.text     "css"
    t.text     "js"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "cms_layouts", ["parent_id", "position"], name: "index_cms_layouts_on_parent_id_and_position", using: :btree
  add_index "cms_layouts", ["site_id", "identifier"], name: "index_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree

  create_table "cms_pages", force: true do |t|
    t.integer  "site_id",                        null: false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",                          null: false
    t.string   "slug"
    t.string   "full_path",                      null: false
    t.text     "content"
    t.integer  "position",       default: 0,     null: false
    t.integer  "children_count", default: 0,     null: false
    t.boolean  "is_published",   default: true,  null: false
    t.boolean  "is_shared",      default: false, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "cms_pages", ["parent_id", "position"], name: "index_cms_pages_on_parent_id_and_position", using: :btree
  add_index "cms_pages", ["site_id", "full_path"], name: "index_cms_pages_on_site_id_and_full_path", using: :btree

  create_table "cms_revisions", force: true do |t|
    t.string   "record_type", null: false
    t.integer  "record_id",   null: false
    t.text     "data"
    t.datetime "created_at"
  end

  add_index "cms_revisions", ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at", using: :btree

  create_table "cms_sites", force: true do |t|
    t.string  "label",                       null: false
    t.string  "identifier",                  null: false
    t.string  "hostname",                    null: false
    t.string  "path"
    t.string  "locale",      default: "en",  null: false
    t.boolean "is_mirrored", default: false, null: false
  end

  add_index "cms_sites", ["hostname"], name: "index_cms_sites_on_hostname", using: :btree
  add_index "cms_sites", ["is_mirrored"], name: "index_cms_sites_on_is_mirrored", using: :btree

  create_table "cms_snippets", force: true do |t|
    t.integer  "site_id",                    null: false
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "cms_snippets", ["site_id", "identifier"], name: "index_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
  add_index "cms_snippets", ["site_id", "position"], name: "index_cms_snippets_on_site_id_and_position", using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "owner_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "course_goals", force: true do |t|
    t.integer  "course_id"
    t.integer  "goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "course_goals", ["course_id"], name: "index_course_goals_on_course_id", using: :btree
  add_index "course_goals", ["goal_id"], name: "index_course_goals_on_goal_id", using: :btree

  create_table "course_users", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "course_users", ["course_id"], name: "index_course_users_on_course_id", using: :btree
  add_index "course_users", ["user_id"], name: "index_course_users_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "cost"
    t.text     "description"
    t.integer  "owner_id"
    t.integer  "review_positive",                                    default: 0
    t.integer  "review_negative",                                    default: 0
    t.integer  "up_votes",                                           default: 0
    t.integer  "down_votes",                                         default: 0
    t.boolean  "hidden",                                             default: false
    t.text     "google_conversion_tracking"
    t.decimal  "affiliate_commission",       precision: 6, scale: 3, default: 50.0
    t.integer  "default_market_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  add_index "courses", ["default_market_id"], name: "index_courses_on_default_market_id", using: :btree
  add_index "courses", ["owner_id"], name: "index_courses_on_owner_id", using: :btree

  create_table "feedbacks", force: true do |t|
    t.integer  "feedback_type", default: 1
    t.integer  "owner_id"
    t.text     "content"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "feedbacks", ["owner_id"], name: "index_feedbacks_on_owner_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "goal_user_jewels", force: true do |t|
    t.integer  "goal_id"
    t.integer  "goal_user_id"
    t.integer  "jewel_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "goal_user_jewels", ["goal_id"], name: "index_goal_user_jewels_on_goal_id", using: :btree
  add_index "goal_user_jewels", ["goal_user_id"], name: "index_goal_user_jewels_on_goal_user_id", using: :btree
  add_index "goal_user_jewels", ["jewel_id"], name: "index_goal_user_jewels_on_jewel_id", using: :btree

  create_table "goal_user_supporters", force: true do |t|
    t.integer  "goal_user_id"
    t.integer  "supporter_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "goal_user_supporters", ["goal_user_id"], name: "index_goal_user_supporters_on_goal_user_id", using: :btree
  add_index "goal_user_supporters", ["supporter_id"], name: "index_goal_user_supporters_on_supporter_id", using: :btree

  create_table "goal_users", force: true do |t|
    t.boolean  "private",    default: true
    t.boolean  "archived",   default: false
    t.boolean  "completed",  default: false
    t.integer  "user_id"
    t.integer  "goal_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "goal_users", ["goal_id"], name: "index_goal_users_on_goal_id", using: :btree
  add_index "goal_users", ["user_id"], name: "index_goal_users_on_user_id", using: :btree

  create_table "goals", force: true do |t|
    t.string   "name"
    t.boolean  "hidden",              default: false
    t.boolean  "welcome",             default: false
    t.integer  "ordering",            default: 9999
    t.integer  "user_count"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "up_votes",            default: 0
    t.integer  "down_votes",          default: 0
    t.integer  "category_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "goals", ["category_id"], name: "index_goals_on_category_id", using: :btree

  create_table "identities", force: true do |t|
    t.text     "access_token"
    t.string   "uid"
    t.string   "provider"
    t.string   "identifier"
    t.integer  "owner_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "identities", ["owner_id"], name: "index_identities_on_owner_id", using: :btree

  create_table "jewels", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "up_votes",            default: 0
    t.integer  "down_votes",          default: 0
    t.text     "content"
    t.text     "url"
    t.text     "parameters"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "owner_id"
    t.integer  "kind"
    t.integer  "goal_id"
    t.integer  "course_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "jewels", ["owner_id"], name: "index_jewels_on_owner_id", using: :btree

  create_table "lectures", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.text     "content"
    t.integer  "position",    default: 0
    t.integer  "section_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "lectures", ["section_id"], name: "index_lectures_on_section_id", using: :btree

  create_table "market_features", force: true do |t|
    t.integer  "market_id"
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "weight",              default: 0
  end

  add_index "market_features", ["market_id"], name: "index_market_features_on_market_id", using: :btree

  create_table "markets", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "affiliate_tag"
    t.text     "content"
    t.boolean  "hidden",              default: false
    t.boolean  "slider",              default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "course_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "subheader"
  end

  add_index "markets", ["course_id"], name: "index_markets_on_course_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "transaction_id"
    t.string   "subscriber_id"
    t.text     "parameters"
    t.integer  "status"
    t.integer  "cost",             default: 0
    t.integer  "course_id"
    t.integer  "market_id"
    t.integer  "user_id"
    t.integer  "gateway"
    t.string   "card_firstname"
    t.string   "card_lastname"
    t.string   "card_email"
    t.string   "card_type"
    t.integer  "card_number_4"
    t.integer  "card_exp_year"
    t.integer  "card_exp_month"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "billing_company"
    t.string   "billing_phone"
    t.string   "billing_zip"
    t.string   "billing_city"
    t.string   "billing_country"
    t.string   "billing_state"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "orders", ["course_id"], name: "index_orders_on_course_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payloads", force: true do |t|
    t.string   "payload_file_name"
    t.string   "payload_content_type"
    t.integer  "payload_file_size"
    t.datetime "payload_updated_at"
    t.integer  "intended_type"
    t.integer  "payloadable_id"
    t.string   "payloadable_type"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "dropbox_path"
  end

  create_table "poll_choices", force: true do |t|
    t.string   "name"
    t.integer  "poll_question_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "poll_choices", ["poll_question_id"], name: "index_poll_choices_on_poll_question_id", using: :btree

  create_table "poll_questions", force: true do |t|
    t.string   "name"
    t.boolean  "display_results", default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "poll_results", force: true do |t|
    t.integer  "poll_question_id"
    t.integer  "poll_choice_id"
    t.integer  "owner_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "poll_results", ["owner_id"], name: "index_poll_results_on_owner_id", using: :btree
  add_index "poll_results", ["poll_choice_id"], name: "index_poll_results_on_poll_choice_id", using: :btree
  add_index "poll_results", ["poll_question_id"], name: "index_poll_results_on_poll_question_id", using: :btree

  create_table "replies", force: true do |t|
    t.text     "content"
    t.integer  "comment_id"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "replies", ["comment_id"], name: "index_replies_on_comment_id", using: :btree

  create_table "reviews", force: true do |t|
    t.text     "content"
    t.boolean  "recommended", default: true
    t.integer  "owner_id"
    t.integer  "course_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
  end

  add_index "reviews", ["course_id"], name: "index_reviews_on_course_id", using: :btree
  add_index "reviews", ["owner_id"], name: "index_reviews_on_owner_id", using: :btree

  create_table "sections", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.text     "content"
    t.integer  "course_id"
    t.integer  "position",    default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "sections", ["course_id"], name: "index_sections_on_course_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.boolean  "has_password",                 default: true
    t.datetime "identity_unlocked_at",         default: '1970-01-01 01:01:00', null: false
    t.text     "about"
    t.text     "instructor_about"
    t.text     "notes"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.string   "timezone",                     default: "Etc/Zulu"
    t.string   "tagline",                      default: ""
    t.string   "affiliate_tag"
    t.integer  "affiliate_default_payment_id"
    t.integer  "affiliate_payment_frequency"
    t.boolean  "access_normal",                default: true
    t.boolean  "access_affiliate",             default: false
    t.boolean  "access_instructor",            default: false
    t.boolean  "access_support",               default: false
    t.boolean  "access_admin",                 default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "toured",                       default: false
    t.integer  "goal_count",                   default: 0
    t.integer  "course_count",                 default: 0
    t.string   "email",                        default: "",                    null: false
    t.string   "encrypted_password",           default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",              default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.boolean  "fake",                         default: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.boolean  "up_vote"
    t.boolean  "down_vote"
    t.integer  "owner_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "votes", ["votable_id"], name: "index_votes_on_votable_id", using: :btree

end
