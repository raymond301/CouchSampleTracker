class CreateDemographicGlobs < ActiveRecord::Migration
  def change
    create_table :demographic_globs do |t|
      t.references :sample, index: true
      t.binary :delim_header
      t.binary :delim_text
    end
  end
end
