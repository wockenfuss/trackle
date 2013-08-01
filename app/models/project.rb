class Project < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	has_many :assignments, :dependent => :destroy
	has_and_belongs_to_many :tasks

	validates :name, :presence => true
	validates :color, :presence => true
  attr_accessible :deadline, :name, :color, :task_ids, :completed_at, :task_id, :update_type, :completed
  attr_accessor :task_id, :update_type, :completed
  before_save :handle_task
  before_save :check_for_completion

  def self.incomplete
  	Project.where('completed_at is NULL').order('updated_at desc')
  end

  def update_notice
  	return "Project completed" if self.completed == "true"
  	return "Project marked incomplete" if self.completed == "false"
  end

  def redirect_path
  	return archives_path if self.completed == "true"
  	return projects_path if self.completed == "false"
  end

  private 
  def handle_task
  	if self.update_type
  		task = Task.find(self.task_id)
  		self.tasks.delete(task) if self.update_type == "delete"
 			self.tasks << task unless self.tasks.include?(task) if self.update_type == "add"
 		end
  end

  def check_for_completion
  	if self.completed == "true"
  		self.completed_at = Time.now
  	elsif self.completed == "false"
  		self.completed_at = nil
  	end
  end
end
