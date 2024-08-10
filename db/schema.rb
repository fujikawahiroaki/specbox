# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_08_08_223048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "all_taxa", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.string "kingdom", limit: 30, null: false
    t.string "phylum", limit: 30, null: false
    t.string "class_name", limit: 30, null: false
    t.string "order", limit: 30, null: false
    t.string "suborder", limit: 30, null: false
    t.string "family", limit: 30, null: false
    t.string "subfamily", limit: 30, null: false
    t.string "tribe", limit: 30, null: false
    t.string "subtribe", limit: 30, null: false
    t.string "genus", limit: 30, null: false
    t.string "subgenus", limit: 30, null: false
    t.string "species", limit: 30, null: false
    t.string "subspecies", limit: 30, null: false
    t.string "scientific_name_author", limit: 50, null: false
    t.integer "name_publishedin_year", null: false
    t.string "japanese_name", limit: 30, null: false
    t.string "distribution", limit: 500, null: false
    t.text "note", null: false
    t.string "image1", limit: 100
    t.string "image2", limit: 100
    t.string "image3", limit: 100
    t.string "image4", limit: 100
    t.string "image5", limit: 100
    t.boolean "change_genus_brackets", null: false
    t.boolean "unknown_author_brackets", null: false
    t.boolean "unknown_name_publishedin_year_brackets", null: false
    t.integer "actual_dist_year", null: false
  end

  create_table "auth_group", id: :serial, force: :cascade do |t|
    t.string "name", limit: 150, null: false
    t.index ["name"], name: "auth_group_name_a6ea08ec_like", opclass: :varchar_pattern_ops
    t.unique_constraint ["name"], name: "auth_group_name_key"
  end

  create_table "auth_group_permissions", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "permission_id", null: false
    t.index ["group_id"], name: "auth_group_permissions_group_id_b120cbf9"
    t.index ["permission_id"], name: "auth_group_permissions_permission_id_84c5c92e"
    t.unique_constraint ["group_id", "permission_id"], name: "auth_group_permissions_group_id_permission_id_0cd325b0_uniq"
  end

  create_table "auth_permission", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "content_type_id", null: false
    t.string "codename", limit: 100, null: false
    t.index ["content_type_id"], name: "auth_permission_content_type_id_2f476e4b"
    t.unique_constraint ["content_type_id", "codename"], name: "auth_permission_content_type_id_codename_01ab375a_uniq"
  end

  create_table "auth_user", id: :serial, force: :cascade do |t|
    t.string "password", limit: 128, null: false
    t.timestamptz "last_login"
    t.boolean "is_superuser", null: false
    t.string "username", limit: 150, null: false
    t.string "first_name", limit: 150, null: false
    t.string "last_name", limit: 150, null: false
    t.string "email", limit: 254, null: false
    t.boolean "is_staff", null: false
    t.boolean "is_active", null: false
    t.timestamptz "date_joined", null: false
    t.index ["username"], name: "auth_user_username_6821ab7c_like", opclass: :varchar_pattern_ops
    t.unique_constraint ["username"], name: "auth_user_username_key"
  end

  create_table "auth_user_groups", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id"], name: "auth_user_groups_group_id_97559544"
    t.index ["user_id"], name: "auth_user_groups_user_id_6a12ed8b"
    t.unique_constraint ["user_id", "group_id"], name: "auth_user_groups_user_id_group_id_94350c0c_uniq"
  end

  create_table "auth_user_user_permissions", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "permission_id", null: false
    t.index ["permission_id"], name: "auth_user_user_permissions_permission_id_1fbb5f2c"
    t.index ["user_id"], name: "auth_user_user_permissions_user_id_a95ead1b"
    t.unique_constraint ["user_id", "permission_id"], name: "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq"
  end

  create_table "collect_points", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.string "contient", limit: 20, null: false
    t.string "island_group", limit: 30, null: false
    t.string "island", limit: 24, null: false
    t.string "country", limit: 2, null: false
    t.string "state_provice", limit: 30, null: false
    t.string "county", limit: 30, null: false
    t.string "municipality", limit: 50, null: false
    t.text "verbatim_locality", null: false
    t.string "japanese_place_name", limit: 14, null: false
    t.string "japanese_place_name_detail", limit: 50, null: false
    t.float "coordinate_precision", null: false
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.float "minimum_elevation", null: false
    t.float "maximum_elevation", null: false
    t.float "minimum_depth", null: false
    t.float "maximum_depth", null: false
    t.text "note", null: false
    t.string "image1", limit: 100
    t.string "image2", limit: 100
    t.string "image3", limit: 100
    t.string "image4", limit: 100
    t.string "image5", limit: 100
    t.integer "user_id"
    t.index ["location"], name: "collect_points_location_id", using: :gist
    t.index ["user_id"], name: "collect_points_user_id_703b22e9"
  end

  create_table "collect_points_tour", id: :serial, force: :cascade do |t|
    t.uuid "collectpoint_id", null: false
    t.uuid "tour_id", null: false
    t.index ["collectpoint_id"], name: "collect_points_tour_collectpoint_id_f5ae5bdf"
    t.index ["tour_id"], name: "collect_points_tour_tour_id_918738ef"
    t.unique_constraint ["collectpoint_id", "tour_id"], name: "collect_points_tour_collectpoint_id_tour_id_7c17bf1d_uniq"
  end

  create_table "collection_settings", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.string "collection_name", limit: 174, null: false
    t.string "institution_code", limit: 10, null: false
    t.integer "latest_collection_code", null: false
    t.text "note", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "collection_settings_user_id_a53a3b72"
  end

  create_table "custom_taxa", primary_key: "taxon_ptr_id", id: :uuid, default: nil, force: :cascade do |t|
    t.boolean "is_private", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "custom_taxa_user_id_a173fd51"
  end

  create_table "default_taxa", primary_key: "taxon_ptr_id", id: :uuid, default: nil, force: :cascade do |t|
    t.boolean "is_private", null: false
  end

  create_table "django_admin_log", id: :serial, force: :cascade do |t|
    t.timestamptz "action_time", null: false
    t.text "object_id"
    t.string "object_repr", limit: 200, null: false
    t.integer "action_flag", limit: 2, null: false
    t.text "change_message", null: false
    t.integer "content_type_id"
    t.integer "user_id", null: false
    t.index ["content_type_id"], name: "django_admin_log_content_type_id_c4bce8eb"
    t.index ["user_id"], name: "django_admin_log_user_id_c564eba6"
    t.check_constraint "action_flag >= 0", name: "django_admin_log_action_flag_check"
  end

  create_table "django_content_type", id: :serial, force: :cascade do |t|
    t.string "app_label", limit: 100, null: false
    t.string "model", limit: 100, null: false

    t.unique_constraint ["app_label", "model"], name: "django_content_type_app_label_model_76bd3d3b_uniq"
  end

  create_table "django_migrations", id: :serial, force: :cascade do |t|
    t.string "app", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.timestamptz "applied", null: false
  end

  create_table "django_session", primary_key: "session_key", id: { type: :string, limit: 40 }, force: :cascade do |t|
    t.text "session_data", null: false
    t.timestamptz "expire_date", null: false
    t.index ["expire_date"], name: "django_session_expire_date_a5c62663"
    t.index ["session_key"], name: "django_session_session_key_c0390e0f_like", opclass: :varchar_pattern_ops
  end

  create_table "migrations", force: :cascade do |t|
    t.bigint "version", null: false
    t.index ["version"], name: "migrations_version_index", unique: true
  end

  create_table "specimen_labels", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.string "name", limit: 30, null: false
    t.boolean "data_label_flag", null: false
    t.boolean "coll_label_flag", null: false
    t.boolean "det_label_flag", null: false
    t.boolean "note_label_flag", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "specimen_labels_user_id_c3656e70"
  end

  create_table "specimen_labels_label_specimens", id: :serial, force: :cascade do |t|
    t.uuid "specimenlabel_id", null: false
    t.uuid "specimen_id", null: false
    t.index ["specimen_id"], name: "specimen_labels_label_specimens_specimen_id_856421f1"
    t.index ["specimenlabel_id"], name: "specimen_labels_label_specimens_specimenlabel_id_ca839f7e"
    t.unique_constraint ["specimenlabel_id", "specimen_id"], name: "specimen_labels_label_sp_specimenlabel_id_specime_ec0a5d9f_uniq"
  end

  create_table "specimens", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "date_last_modified", null: false
    t.integer "collection_code", null: false
    t.string "identified_by", limit: 18, null: false
    t.date "date_identified", null: false
    t.string "collecter", limit: 18, null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "day", null: false
    t.string "sex", limit: 1, null: false
    t.string "preparation_type", limit: 20, null: false
    t.string "disposition", limit: 30, null: false
    t.string "sampling_protocol", limit: 20, null: false
    t.text "sampling_effort", null: false
    t.string "lifestage", limit: 20, null: false
    t.string "establishment_means", limit: 20, null: false
    t.string "rights", limit: 10, null: false
    t.text "note", null: false
    t.string "image1", limit: 100
    t.string "image2", limit: 100
    t.string "image3", limit: 100
    t.string "image4", limit: 100
    t.string "image5", limit: 100
    t.uuid "collect_point_info_id"
    t.uuid "collection_settings_info_id"
    t.uuid "custom_taxon_info_id"
    t.uuid "default_taxon_info_id"
    t.uuid "tour_id"
    t.integer "user_id"
    t.boolean "allow_kojin_shuzo", null: false
    t.boolean "published_kojin_shuzo", null: false
    t.index ["collect_point_info_id"], name: "specimens_collect_point_info_id_6be0fbc5"
    t.index ["collection_settings_info_id"], name: "specimens_collection_settings_info_id_fb09849f"
    t.index ["custom_taxon_info_id"], name: "specimens_custom_taxon_info_id_bbee011b"
    t.index ["default_taxon_info_id"], name: "specimens_default_taxon_info_id_a610fe3b"
    t.index ["tour_id"], name: "specimens_tour_id_41cb13e4"
    t.index ["user_id"], name: "specimens_user_id_c7d6bf28"
  end

  create_table "tours", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.string "title", limit: 30, null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.geography "track", limit: {:srid=>4326, :type=>"line_string", :geographic=>true}
    t.text "note", null: false
    t.string "image1", limit: 100
    t.string "image2", limit: 100
    t.string "image3", limit: 100
    t.string "image4", limit: 100
    t.string "image5", limit: 100
    t.integer "user_id"
    t.index ["track"], name: "tours_track_id", using: :gist
    t.index ["user_id"], name: "tours_user_id_f66f4e85"
  end

  create_table "user_profiles", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.string "contient", limit: 20, null: false
    t.string "island_group", limit: 30, null: false
    t.string "island", limit: 24, null: false
    t.string "country", limit: 2, null: false
    t.string "state_provice", limit: 30, null: false
    t.string "identified_by", limit: 19, null: false
    t.string "collecter", limit: 18, null: false
    t.string "preparation_type", limit: 20, null: false
    t.string "disposition", limit: 30, null: false
    t.string "lifestage", limit: 20, null: false
    t.string "establishment_means", limit: 20, null: false
    t.string "rights", limit: 10, null: false
    t.string "kingdom", limit: 30, null: false
    t.string "phylum", limit: 30, null: false
    t.string "class_name", limit: 30, null: false
    t.string "order", limit: 30, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "user_profiles_user_id_8c5ab5fe"
  end

  create_table "users", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.citext "email", null: false
    t.text "encrypted_password", null: false
    t.index ["email"], name: "users_email_index", unique: true
  end

  add_foreign_key "auth_group_permissions", "auth_group", column: "group_id", name: "auth_group_permissions_group_id_b120cbf9_fk_auth_group_id", deferrable: :deferred
  add_foreign_key "auth_group_permissions", "auth_permission", column: "permission_id", name: "auth_group_permissio_permission_id_84c5c92e_fk_auth_perm", deferrable: :deferred
  add_foreign_key "auth_permission", "django_content_type", column: "content_type_id", name: "auth_permission_content_type_id_2f476e4b_fk_django_co", deferrable: :deferred
  add_foreign_key "auth_user_groups", "auth_group", column: "group_id", name: "auth_user_groups_group_id_97559544_fk_auth_group_id", deferrable: :deferred
  add_foreign_key "auth_user_groups", "auth_user", column: "user_id", name: "auth_user_groups_user_id_6a12ed8b_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "auth_user_user_permissions", "auth_permission", column: "permission_id", name: "auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm", deferrable: :deferred
  add_foreign_key "auth_user_user_permissions", "auth_user", column: "user_id", name: "auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "collect_points", "auth_user", column: "user_id", name: "collect_points_user_id_703b22e9_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "collect_points_tour", "collect_points", column: "collectpoint_id", name: "collect_points_tour_collectpoint_id_f5ae5bdf_fk_collect_p", deferrable: :deferred
  add_foreign_key "collect_points_tour", "tours", name: "collect_points_tour_tour_id_918738ef_fk_tours_id", deferrable: :deferred
  add_foreign_key "collection_settings", "auth_user", column: "user_id", name: "collection_settings_user_id_a53a3b72_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "custom_taxa", "all_taxa", column: "taxon_ptr_id", name: "custom_taxa_taxon_ptr_id_68d49116_fk_all_taxa_id", deferrable: :deferred
  add_foreign_key "custom_taxa", "auth_user", column: "user_id", name: "custom_taxa_user_id_a173fd51_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "default_taxa", "all_taxa", column: "taxon_ptr_id", name: "default_taxa_taxon_ptr_id_18b91e6f_fk_all_taxa_id", deferrable: :deferred
  add_foreign_key "django_admin_log", "auth_user", column: "user_id", name: "django_admin_log_user_id_c564eba6_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "django_admin_log", "django_content_type", column: "content_type_id", name: "django_admin_log_content_type_id_c4bce8eb_fk_django_co", deferrable: :deferred
  add_foreign_key "specimen_labels", "auth_user", column: "user_id", name: "specimen_labels_user_id_c3656e70_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "specimen_labels_label_specimens", "specimen_labels", column: "specimenlabel_id", name: "specimen_labels_labe_specimenlabel_id_ca839f7e_fk_specimen_", deferrable: :deferred
  add_foreign_key "specimen_labels_label_specimens", "specimens", name: "specimen_labels_labe_specimen_id_856421f1_fk_specimens", deferrable: :deferred
  add_foreign_key "specimens", "auth_user", column: "user_id", name: "specimens_user_id_c7d6bf28_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "specimens", "collect_points", column: "collect_point_info_id", name: "specimens_collect_point_info_id_6be0fbc5_fk_collect_points_id", deferrable: :deferred
  add_foreign_key "specimens", "collection_settings", column: "collection_settings_info_id", name: "specimens_collection_settings__fb09849f_fk_collectio", deferrable: :deferred
  add_foreign_key "specimens", "custom_taxa", column: "custom_taxon_info_id", primary_key: "taxon_ptr_id", name: "specimens_custom_taxon_info_id_bbee011b_fk_custom_ta", deferrable: :deferred
  add_foreign_key "specimens", "default_taxa", column: "default_taxon_info_id", primary_key: "taxon_ptr_id", name: "specimens_default_taxon_info_i_a610fe3b_fk_default_t", deferrable: :deferred
  add_foreign_key "specimens", "tours", name: "specimens_tour_id_41cb13e4_fk_tours_id", deferrable: :deferred
  add_foreign_key "tours", "auth_user", column: "user_id", name: "tours_user_id_f66f4e85_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "user_profiles", "auth_user", column: "user_id", name: "user_profiles_user_id_8c5ab5fe_fk_auth_user_id", deferrable: :deferred
end
