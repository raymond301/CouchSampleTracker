class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :gender
      t.string :ethnicity
      t.string :cancer_type
      t.string :tissue_source
      t.string :case_control
      t.string :species
      t.string :aliquot_from
      t.boolean :failure, :default => false
      t.references :site_of_origin
      t.timestamps
    end
  end
end
