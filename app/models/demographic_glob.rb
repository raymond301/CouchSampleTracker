class DemographicGlob < ActiveRecord::Base
  belongs_to :sample
  belongs_to :demographic_glob_header
end
