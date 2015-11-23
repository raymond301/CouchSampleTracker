class Sample < ActiveRecord::Base
  has_many :sample_aliases
  belongs_to :site_of_origin
  has_and_belongs_to_many :projects
end
