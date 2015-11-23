class CreateDemographicGlobs < ActiveRecord::Migration
  def change
    create_table :demographic_globs do |t|
      t.references :sample, index: true
      t.references :demographic_glob_header, index: true
      t.text :delim_text
    end
  end
end
