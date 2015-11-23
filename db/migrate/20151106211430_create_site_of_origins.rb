class CreateSiteOfOrigins < ActiveRecord::Migration
  def change
    create_table :site_of_origins do |t|
      t.string :institution
      t.string :study_group
      t.string :contact
      t.string :contact_email
      t.string :contact_phone
      t.string :additional_details
    end
  end
end
