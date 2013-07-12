class User < ActiveRecord::Base
	has_many :assignments
	has_many :tasks, :through => :assignments
	validates :name, :presence => true
  attr_accessible :absent, :available, :email, :name

  def current_city_color
  	if self.assignments.any?
			return "#{self.assignments.first.city.color}"
		else 
			return 'lightgreen'
		end
  end

  def task_color
  	if self.assignments.any?
			return "#{self.assignments.first.task.color}"
		else 
			return 'lightgreen'
		end
  end
end
