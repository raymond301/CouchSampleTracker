class CreateSampleNotes < ActiveRecord::Migration
  def change
    create_table :sample_notes do |t|
      t.references :sample, index: true
      t.string :title
      t.string :submitter
      t.text :description
      t.timestamps
    end
  end
end
