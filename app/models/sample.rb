class Sample < ActiveRecord::Base
  has_many :sample_aliases
  belongs_to :site_of_origin
  has_and_belongs_to_many :projects


  def primeName
     SampleAliase.where(['sample_id = ? AND top = ?', self.id, true]).first
  end

  def listNames
    SampleAliase.where(['sample_id = ?', self.id]).map{|s| s.name}.join(", ")
  end

end
