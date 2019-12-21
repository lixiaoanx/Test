# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 51) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "aggregation_conditions", force: :cascade do |t|
    t.bigint "custom_query_id", null: false
    t.bigint "field_id", null: false
    t.string "aggregation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["custom_query_id"], name: "index_aggregation_conditions_on_custom_query_id"
    t.index ["field_id"], name: "index_aggregation_conditions_on_field_id"
  end

  create_table "choices", force: :cascade do |t|
    t.bigint "field_id"
    t.text "label", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
    t.index ["field_id"], name: "index_choices_on_field_id"
  end

  create_table "custom_queries", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "form_id", null: false
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["form_id"], name: "index_custom_queries_on_form_id"
    t.index ["tenant_id"], name: "index_custom_queries_on_tenant_id"
  end

  create_table "dictionaries", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "value", default: "", null: false
    t.string "scope", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["scope"], name: "index_dictionaries_on_scope"
    t.index ["tenant_id"], name: "index_dictionaries_on_tenant_id"
    t.index ["value"], name: "index_dictionaries_on_value"
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "project_id"
    t.bigint "form_id"
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.index ["form_id"], name: "index_entries_on_form_id"
    t.index ["parent_id"], name: "index_entries_on_parent_id"
    t.index ["project_id"], name: "index_entries_on_project_id"
    t.index ["tenant_id"], name: "index_entries_on_tenant_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name", null: false
    t.integer "accessibility", null: false
    t.text "validations"
    t.text "options"
    t.string "type", null: false
    t.bigint "form_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "label", default: ""
    t.string "hint", default: ""
    t.integer "position"
    t.text "script"
    t.index ["form_id", "name"], name: "index_fields_on_form_id_and_name", unique: true
    t.index ["form_id"], name: "index_fields_on_form_id"
    t.index ["type"], name: "index_fields_on_type"
  end

  create_table "filter_conditions", force: :cascade do |t|
    t.bigint "custom_query_id", null: false
    t.bigint "field_id"
    t.text "options"
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["custom_query_id"], name: "index_filter_conditions_on_custom_query_id"
    t.index ["field_id"], name: "index_filter_conditions_on_field_id"
  end

  create_table "forms", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", default: ""
    t.text "description", default: ""
    t.bigint "project_id"
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.index ["attachable_type", "attachable_id"], name: "index_forms_on_attachable_type_and_attachable_id"
    t.index ["name"], name: "index_forms_on_name", unique: true
    t.index ["project_id"], name: "index_forms_on_project_id"
    t.index ["tenant_id"], name: "index_forms_on_tenant_id"
    t.index ["type"], name: "index_forms_on_type"
  end

  create_table "group_by_conditions", force: :cascade do |t|
    t.bigint "custom_query_id", null: false
    t.bigint "field_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["custom_query_id"], name: "index_group_by_conditions_on_custom_query_id"
    t.index ["field_id"], name: "index_group_by_conditions_on_field_id"
  end

  create_table "groups", comment: "成员组织", force: :cascade do |t|
    t.bigint "tenant_id", null: false, comment: "租户ID"
    t.bigint "project_id", null: false, comment: "项目ID"
    t.string "name", null: false, comment: "组织名称"
    t.bigint "parent_id", comment: "父级组织ID"
    t.integer "children_count", default: 0, comment: "下级组织数量；标记是否末级组织；children count为0就是末级组织"
    t.bigint "path", default: [], comment: "上级路径", array: true
    t.integer "depth", default: 1, comment: "深度；root的深度为1"
    t.integer "members_count", default: 0, comment: "拥有成员数量"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type", null: false
    t.index ["path"], name: "index_groups_on_path", using: :gin
    t.index ["project_id", "path"], name: "index_groups_on_project_id_and_path", using: :gin
    t.index ["project_id"], name: "index_groups_on_project_id"
    t.index ["tenant_id"], name: "index_groups_on_tenant_id"
  end

  create_table "member_groups", comment: "组织和成员关系", force: :cascade do |t|
    t.bigint "member_id", null: false, comment: "成员ID"
    t.bigint "group_id", null: false, comment: "组织ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id", "member_id"], name: "index_member_groups_on_group_id_and_member_id", unique: true
  end

  create_table "members", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "role_id", null: false
    t.bigint "user_id"
    t.bigint "redmine_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_members_on_role_id"
    t.index ["tenant_id"], name: "index_members_on_tenant_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "project_trackers", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "project_id", null: false
    t.bigint "redmine_tracker_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "workflow_id", null: false
    t.index ["project_id"], name: "index_project_trackers_on_project_id"
    t.index ["tenant_id"], name: "index_project_trackers_on_tenant_id"
    t.index ["workflow_id"], name: "index_project_trackers_on_workflow_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "redmine_project_id"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id"], name: "index_projects_on_tenant_id"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id"], name: "index_roles_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "permalink", null: false
    t.string "name", null: false
    t.string "redmine_host"
    t.string "redmine_secret"
    t.string "redmine_database_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_tenants_on_creator_id"
    t.index ["permalink"], name: "index_tenants_on_permalink", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "workflow_accessibilities", force: :cascade do |t|
    t.bigint "workflow_id", null: false
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["target_type", "target_id"], name: "index_workflow_accessibilities_on_target_type_and_target_id"
    t.index ["workflow_id"], name: "index_workflow_accessibilities_on_workflow_id"
  end

  create_table "workflow_categories", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "project_id"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_workflow_categories_on_project_id"
    t.index ["tenant_id"], name: "index_workflow_categories_on_tenant_id"
  end

  create_table "workflow_instance_observations", force: :cascade do |t|
    t.bigint "instance_id", null: false
    t.string "observable_type", null: false
    t.bigint "observable_id", null: false
    t.string "granted_by_type"
    t.bigint "granted_by_id"
    t.boolean "read", default: false, null: false
    t.text "options"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "workflow_id", null: false
    t.text "comment"
    t.bigint "project_id", null: false
    t.index ["instance_id"], name: "index_workflow_instance_observations_on_instance_id"
    t.index ["observable_type", "observable_id"], name: "idx_observable_type_and_observable_id"
    t.index ["project_id"], name: "index_workflow_instance_observations_on_project_id"
    t.index ["workflow_id"], name: "index_workflow_instance_observations_on_workflow_id"
  end

  create_table "workflow_instances", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.text "payload"
    t.integer "status", default: 0, null: false
    t.bigint "workflow_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "creator_id"
    t.bigint "project_id"
    t.string "type"
    t.bigint "redmine_issue_id"
    t.string "closed_by_type"
    t.bigint "closed_by_id"
    t.index ["closed_by_type", "closed_by_id"], name: "index_workflow_instances_on_closed_by_type_and_closed_by_id"
    t.index ["creator_id"], name: "index_workflow_instances_on_creator_id"
    t.index ["project_id"], name: "index_workflow_instances_on_project_id"
    t.index ["tenant_id"], name: "index_workflow_instances_on_tenant_id"
    t.index ["workflow_id"], name: "index_workflow_instances_on_workflow_id"
  end

  create_table "workflow_places", force: :cascade do |t|
    t.bigint "input_transition_id"
    t.bigint "output_transition_id"
    t.string "type", null: false
    t.bigint "workflow_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.string "uid"
    t.index ["input_transition_id"], name: "index_workflow_places_on_input_transition_id"
    t.index ["output_transition_id"], name: "index_workflow_places_on_output_transition_id"
    t.index ["workflow_id"], name: "index_workflow_places_on_workflow_id"
  end

  create_table "workflow_tokens", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.bigint "place_id"
    t.bigint "previous_id"
    t.bigint "instance_id"
    t.bigint "workflow_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.bigint "project_id"
    t.bigint "tenant_id", null: false
    t.boolean "hidden", default: false
    t.text "payload"
    t.string "assignable_type"
    t.bigint "assignable_id"
    t.string "forwardable_type"
    t.bigint "forwardable_id"
    t.string "processable_type"
    t.bigint "processable_id"
    t.index ["assignable_type", "assignable_id"], name: "index_workflow_tokens_on_assignable_type_and_assignable_id"
    t.index ["forwardable_type", "forwardable_id"], name: "index_workflow_tokens_on_forwardable_type_and_forwardable_id"
    t.index ["instance_id"], name: "index_workflow_tokens_on_instance_id"
    t.index ["place_id"], name: "index_workflow_tokens_on_place_id"
    t.index ["previous_id"], name: "index_workflow_tokens_on_previous_id"
    t.index ["processable_type", "processable_id"], name: "index_workflow_tokens_on_processable_type_and_processable_id"
    t.index ["project_id"], name: "index_workflow_tokens_on_project_id"
    t.index ["tenant_id"], name: "index_workflow_tokens_on_tenant_id"
    t.index ["workflow_id"], name: "index_workflow_tokens_on_workflow_id"
  end

  create_table "workflow_transitions", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "workflow_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid"
    t.string "title"
    t.text "options"
    t.index ["workflow_id"], name: "index_workflow_transitions_on_workflow_id"
  end

  create_table "workflow_visibilities", force: :cascade do |t|
    t.bigint "workflow_id", null: false
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["target_type", "target_id"], name: "index_workflow_visibilities_on_target_type_and_target_id"
    t.index ["workflow_id"], name: "index_workflow_visibilities_on_workflow_id"
  end

  create_table "workflows", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "description"
    t.bigint "form_id", null: false
    t.bigint "project_id"
    t.integer "state", default: 0, comment: "0-active,1-draft, 2-inactive"
    t.bigint "origin_workflow_id", comment: "关联原始版本工作流"
    t.bigint "category_id"
    t.integer "accessibility", default: 0, null: false
    t.integer "visibility", default: 0, null: false
    t.index ["category_id"], name: "index_workflows_on_category_id"
    t.index ["form_id"], name: "index_workflows_on_form_id"
    t.index ["project_id"], name: "index_workflows_on_project_id"
    t.index ["tenant_id"], name: "index_workflows_on_tenant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "aggregation_conditions", "custom_queries"
  add_foreign_key "aggregation_conditions", "fields"
  add_foreign_key "choices", "fields"
  add_foreign_key "custom_queries", "forms"
  add_foreign_key "custom_queries", "tenants"
  add_foreign_key "dictionaries", "tenants"
  add_foreign_key "entries", "entries", column: "parent_id"
  add_foreign_key "entries", "forms"
  add_foreign_key "entries", "tenants"
  add_foreign_key "fields", "forms"
  add_foreign_key "filter_conditions", "custom_queries"
  add_foreign_key "filter_conditions", "fields"
  add_foreign_key "forms", "tenants"
  add_foreign_key "group_by_conditions", "custom_queries"
  add_foreign_key "group_by_conditions", "fields"
  add_foreign_key "members", "roles"
  add_foreign_key "members", "tenants"
  add_foreign_key "members", "users"
  add_foreign_key "project_trackers", "projects"
  add_foreign_key "project_trackers", "tenants"
  add_foreign_key "project_trackers", "workflows"
  add_foreign_key "projects", "tenants"
  add_foreign_key "roles", "tenants"
  add_foreign_key "tenants", "users", column: "creator_id"
  add_foreign_key "workflow_accessibilities", "workflows"
  add_foreign_key "workflow_categories", "tenants"
  add_foreign_key "workflow_instance_observations", "projects"
  add_foreign_key "workflow_instance_observations", "workflow_instances", column: "instance_id"
  add_foreign_key "workflow_instance_observations", "workflows"
  add_foreign_key "workflow_instances", "members", column: "creator_id"
  add_foreign_key "workflow_instances", "tenants"
  add_foreign_key "workflow_instances", "workflows"
  add_foreign_key "workflow_places", "workflow_transitions", column: "input_transition_id"
  add_foreign_key "workflow_places", "workflow_transitions", column: "output_transition_id"
  add_foreign_key "workflow_places", "workflows"
  add_foreign_key "workflow_tokens", "tenants"
  add_foreign_key "workflow_tokens", "workflow_instances", column: "instance_id"
  add_foreign_key "workflow_tokens", "workflow_places", column: "place_id"
  add_foreign_key "workflow_tokens", "workflow_tokens", column: "previous_id"
  add_foreign_key "workflow_tokens", "workflows"
  add_foreign_key "workflow_transitions", "workflows"
  add_foreign_key "workflow_visibilities", "workflows"
  add_foreign_key "workflows", "tenants"
  add_foreign_key "workflows", "workflow_categories", column: "category_id"
end
