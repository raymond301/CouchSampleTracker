class ChangeTracker < ActiveRecord::Base
  has_and_belongs_to_many :changer, polymorphic: true
end
