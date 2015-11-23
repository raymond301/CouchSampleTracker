class CreateBugTraxes < ActiveRecord::Migration
  def change
    create_table :bug_traxes do |t|
      t.string :submitter
      t.string :url
      t.string :description
      t.string :level
      t.string :tag
      t.boolean :active
      t.timestamps
    end
  end
end
