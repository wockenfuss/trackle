class Task < ActiveRecord::Base
	has_many :assignments
	validates :name, :presence => true
  attr_accessible :name

end
