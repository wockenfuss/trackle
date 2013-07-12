class City < ActiveRecord::Base
	# has_many :tasks
	has_many :assignments, :dependent => :destroy

	validates :name, :presence => true
  attr_accessible :deadline, :name
end
