class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
	has_many :assignments, :order => :queue_index, :dependent => :destroy
	has_many :tasks, :through => :assignments
  has_many :comments
  has_many :announcements
	validates :name, :presence => true
  attr_accessible :absent, :available, :name, :admin
  attr_accessor :admin

  def on_hold
    self.assignments.where(:hold => true)
  end

  def completed_assignments
    self.assignments.where('completed_at is NOT NULL')
  end

  def incomplete_assignments
    self.assignments.where(:completed_at => nil, :hold => false)
  end

  def current_assignment
    if self.incomplete_assignments.first
      return self.incomplete_assignments.first
    elsif self.on_hold
      return self.on_hold.first
    else
      return "none"
    end
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
  	self.incomplete_assignments.count > 0 || self.on_hold.count > 0
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

  def self.non_admin
    @users = []
    User.find_each do |user|
      if !user.has_role? :admin
        @users << user
      end
    end
    @users
  end
end
