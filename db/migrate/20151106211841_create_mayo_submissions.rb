class CreateMayoSubmissions < ActiveRecord::Migration
  def change
    create_table :mayo_submissions do |t|
      t.references :sample, index: true
      t.integer :lane_number
      t.string :sequence_index
      t.string :flowcell
      t.string :ngs_protal_batch
      t.timestamps
    end
  end
end
