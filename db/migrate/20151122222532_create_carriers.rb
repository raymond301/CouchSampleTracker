class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|

      t.timestamps
    end
  end
end
