class Task < ActiveRecord::Base
	has_many :assignments
	validates :name, :presence => true
	validates :color, :presence => true
  attr_accessible :name, :color

end
