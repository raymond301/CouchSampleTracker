class CreateDemographicGlobHeaders < ActiveRecord::Migration
  def change
    create_table :demographic_glob_headers do |t|
      t.references :sample, index: true
      t.text :delim_text
    end
  end
end
