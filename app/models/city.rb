class City < ActiveRecord::Base
	# has_many :tasks
	has_many :assignments, :dependent => :destroy

	validates :name, :presence => true
	validates :color, :presence => true
  attr_accessible :deadline, :name, :color

  # before_save do |city| 
  # 	if !city.color
  # 		city.color = "##{'%06x' % (rand * 0xffffff)}"
  # 	end
  # end

end
