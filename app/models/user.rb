class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
	has_many :assignments, :order => :created_at
	has_many :tasks, :through => :assignments
	validates :name, :presence => true
  attr_accessible :absent, :available, :name, :admin
  attr_accessor :admin

  def completed_assignments
    self.assignments.where('completed_at is NOT NULL')
  end

  def incomplete_assignments
    self.assignments.where(:completed_at => nil)
    # Assignment.where("user_id = ?", self.id)    
    # Assignment.where("user_id = ? AND assignments.completed_at = ?", self.id, nil)
  end

  def current_assignment
  	assigned? ? (return self.incomplete_assignments.first) : (return "none")
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
  	self.incomplete_assignments.count > 0
  end

  def queued
    return self.incomplete_assignments.slice(1..-1) if self.incomplete_assignments.count > 1
  end

  def update_admin(params)
    if params[:admin]
      self.add_role :admin
    else
      self.remove_role :admin
    end
  end
end
