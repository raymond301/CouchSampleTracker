class SampleAliase < ActiveRecord::Base
  belongs_to :sample

  def self.allSamplesInQuery(q)
     sa = SampleAliase.all.where("name like ?", "%#{q}%")
     return sa.map{|a| a.sample}.uniq
  end

end
