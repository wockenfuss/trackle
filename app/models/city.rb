class City < ActiveRecord::Base
	# has_many :tasks
	has_many :assignments, :dependent => :destroy

	validates :name, :presence => true
  attr_accessible :deadline, :name, :color

  before_save { |city| city.color = "%06x" % (rand * 0xffffff) }

end
