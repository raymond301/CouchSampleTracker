class CreateSampleAliases < ActiveRecord::Migration
  def change
    create_table :sample_aliases do |t|
      t.references :sample, index: true
      t.string :name
      t.string :typeCast
      t.boolean :top, :default => false
    end
  end
end
