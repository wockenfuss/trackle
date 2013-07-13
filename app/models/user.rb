class User < ActiveRecord::Base
	has_many :assignments
	has_many :tasks, :through => :assignments
	validates :name, :presence => true
  attr_accessible :absent, :available, :email, :name

  def current_assignment
  	assigned? ? (return self.assignments.first) : (return "none")
  end

  def current_city_color
  	if assigned?
			return current_assignment.city.color
		else 
			return 'lightgreen'
		end
  end

  def task_color
  	if assigned?
			return current_assignment.task.color
		else 
			return 'lightgreen'
		end
  end

  def city_name
  	if assigned?
  		return current_assignment.city.name
  	else
  		return "none"
  	end
  end

  def assigned?
  	self.assignments.any?
  end
end
