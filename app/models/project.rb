class Project < ActiveRecord::Base
	has_many :assignments, :dependent => :destroy

	validates :name, :presence => true
	validates :color, :presence => true
  attr_accessible :deadline, :name, :color
end
