class Task < ActiveRecord::Base
	has_many :assignments
	validates :name, :presence => true
	validates :color, :presence => true
  attr_accessible :name, :color

  def assignments_for_city(city)
  	self.assignments.where(:city_id => city.id)
  end
end
