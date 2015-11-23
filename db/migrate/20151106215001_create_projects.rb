class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :short
      t.integer :total, default=0
      t.integer :cases, default=0
      t.integer :cntls, default=0
      t.text :purpose
      t.timestamps
    end

    create_join_table :projects, :samples
  end
end
