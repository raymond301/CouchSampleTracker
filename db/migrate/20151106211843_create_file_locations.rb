class CreateFileLocations < ActiveRecord::Migration
  def change
    create_table :file_locations do |t|
      t.references :sample, index: true
      t.string :typeCast
      t.string :location
    end
  end
end
