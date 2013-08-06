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
    @on_hold ||= self.assignments.where(:hold => true)
  end

  def completed_assignments
    @completed_assignments ||= self.assignments.where('completed_at is NOT NULL')
  end

  def incomplete_assignments
    @incomplete_assignments ||= self.assignments.where(:completed_at => nil, :hold => false)
    @incomplete_assignments.select { |a| !a.project.completed_at? }
  end

  def current_assignment
    if @current_assignment.nil?
      if self.incomplete_assignments.first
        @current_assignment =  self.incomplete_assignments.first
      elsif self.on_hold
        @current_assignment =  self.on_hold.first
      end
    end
    @current_assignment
  end

  def current_project_color
    assigned? ? (return current_assignment.project.color) : (return 'lightgreen')
  end

  def task_color
    assigned? ? (return current_assignment.task.color) : (return 'lightgreen')
  end

  def project_name
    assigned? ? (return current_assignment.project.name) : (return nil)
  end

  def assigned?
  	self.incomplete_assignments.count > 0 || self.on_hold.count > 0
  end

  def queued
    return self.incomplete_assignments.slice(1..-1) if self.incomplete_assignments.count > 1
  end

  def update_admin(params)
    params[:admin] ? self.add_role(:admin) : self.remove_role(:admin) 
  end

  def self.non_admin
    User.joins("LEFT OUTER JOIN users_roles 
                ON users.id = user_id 
                WHERE user_id is NULL")
                .includes(:assignments)
  end

  def self.admin
    User.joins(:roles).where("roles.name = ?", :admin)
  end
end
