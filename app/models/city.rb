class City < ActiveRecord::Base
	validates :name, :presence => true
  attr_accessible :deadline, :name
end
