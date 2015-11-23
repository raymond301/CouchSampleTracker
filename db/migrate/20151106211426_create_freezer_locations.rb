class CreateFreezerLocations < ActiveRecord::Migration
  def change
    create_table :freezer_locations do |t|
      t.references :sample, index: true
      t.string :plate_barcode
      t.string :plate_name
      t.string :plate_type
      t.string :process_step
      t.string :box_type
      t.string :box
      t.string :tube_barcode
      t.string :well
      t.string :rack
      t.string :freezer_name
      t.string :lab
      t.float :volume
      t.float :concentration
      t.string :concentration_method
      t.string :dna_quality
      t.string :notes
      t.date :last_access
      t.timestamps
    end
  end
end
