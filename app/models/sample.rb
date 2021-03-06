class Sample < ActiveRecord::Base
  has_many :sample_aliases
  belongs_to :site_of_origin
  has_and_belongs_to_many :projects
  has_many :mayo_submissions
  has_many :file_locations
  has_many :freezer_locations
  has_many :demographic_informations
  has_many :validations


  def allNameObjts
    SampleAliase.where(['sample_id = ?', self.id])
  end

  def primeName
     SampleAliase.where(['sample_id = ? AND top = ?', self.id, true]).first
  end

  def allNames
    SampleAliase.where(['sample_id = ?', self.id]).map{|s| s.name}
  end

end
