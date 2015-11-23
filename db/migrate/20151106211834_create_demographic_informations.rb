class CreateDemographicInformations < ActiveRecord::Migration
  def change
    create_table :demographic_informations do |t|
      t.references :sample, index: true
      t.string :title
      t.string :value
    end
  end
end
