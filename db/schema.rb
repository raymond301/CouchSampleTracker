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

ActiveRecord::Schema.define(version: 20151122222532) do

  create_table "bug_traxes", force: true do |t|
    t.string   "submitter"
    t.string   "url"
    t.string   "description"
    t.string   "level"
    t.string   "tag"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demographic_glob_headers", force: true do |t|
    t.integer "sample_id"
    t.text    "delim_text"
  end

  add_index "demographic_glob_headers", ["sample_id"], name: "index_demographic_glob_headers_on_sample_id"

  create_table "demographic_globs", force: true do |t|
    t.integer "sample_id"
    t.integer "demographic_glob_header_id"
    t.text    "delim_text"
  end

  add_index "demographic_globs", ["demographic_glob_header_id"], name: "index_demographic_globs_on_demographic_glob_header_id"
  add_index "demographic_globs", ["sample_id"], name: "index_demographic_globs_on_sample_id"

  create_table "demographic_informations", force: true do |t|
    t.integer "sample_id"
    t.string  "title"
    t.string  "value"
  end

  add_index "demographic_informations", ["sample_id"], name: "index_demographic_informations_on_sample_id"

  create_table "file_locations", force: true do |t|
    t.integer "sample_id"
    t.string  "typeCast"
    t.string  "location"
  end

  add_index "file_locations", ["sample_id"], name: "index_file_locations_on_sample_id"

  create_table "freezer_locations", force: true do |t|
    t.integer  "sample_id"
    t.string   "plate_barcode"
    t.string   "plate_name"
    t.string   "plate_type"
    t.string   "process_step"
    t.string   "box_type"
    t.string   "box"
    t.string   "tube_barcode"
    t.string   "well"
    t.string   "rack"
    t.string   "freezer_name"
    t.string   "lab"
    t.float    "volume"
    t.float    "concentration"
    t.string   "concentration_method"
    t.string   "dna_quality"
    t.string   "notes"
    t.date     "last_access"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "freezer_locations", ["sample_id"], name: "index_freezer_locations_on_sample_id"

  create_table "mayo_submissions", force: true do |t|
    t.integer  "sample_id"
    t.integer  "lane_number"
    t.string   "sequence_index"
    t.string   "flowcell"
    t.string   "ngs_protal_batch"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mayo_submissions", ["sample_id"], name: "index_mayo_submissions_on_sample_id"

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "short"
    t.integer  "total"
    t.integer  "0"
    t.integer  "cases"
    t.integer  "cntls"
    t.text     "purpose"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_samples", id: false, force: true do |t|
    t.integer "project_id", null: false
    t.integer "sample_id",  null: false
  end

  create_table "sample_aliases", force: true do |t|
    t.integer "sample_id"
    t.string  "name"
    t.string  "typeCast"
    t.boolean "top",       default: false
  end

  add_index "sample_aliases", ["sample_id"], name: "index_sample_aliases_on_sample_id"

  create_table "sample_notes", force: true do |t|
    t.integer  "sample_id"
    t.string   "title"
    t.string   "submitter"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_notes", ["sample_id"], name: "index_sample_notes_on_sample_id"

  create_table "samples", force: true do |t|
    t.string   "gender"
    t.string   "ethnicity"
    t.string   "cancer_type"
    t.string   "tissue_source"
    t.string   "case_control"
    t.string   "species"
    t.string   "aliquot_from"
    t.boolean  "failure",           default: false
    t.integer  "site_of_origin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_of_origins", force: true do |t|
    t.string "institution"
    t.string "study_group"
    t.string "contact"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "additional_details"
  end

  create_table "validations", force: true do |t|
    t.integer  "sample_id"
    t.boolean  "confirmation"
    t.string   "reference_build"
    t.string   "chr"
    t.string   "pos"
    t.string   "ref"
    t.string   "alt"
    t.string   "hgvs_c"
    t.string   "hgvs_p"
    t.string   "gene"
    t.string   "transcript"
    t.string   "exon"
    t.string   "primer_forward"
    t.string   "primer_reverse"
    t.integer  "pcr_size"
    t.float    "annealing_temp"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "validations", ["sample_id"], name: "index_validations_on_sample_id"

end
