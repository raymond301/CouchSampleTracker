class CreateChangeTrackers < ActiveRecord::Migration
  def change
    create_table :change_trackers do |t|
      t.integer :changer_id
      t.string :changer_type
      t.string :action
      t.string :title
      t.text :old_value
      t.text :new_value

      t.timestamps
    end
  end
end
