class Task < ActiveRecord::Base
	has_many :assignments
	has_and_belongs_to_many :task_groups
	has_and_belongs_to_many :projects
  before_save :handle_task_group

	validates :name, :presence => true
  attr_accessible :name, :color, :task_group_ids, :project_ids, :task_group_id
  attr_accessor :task_group_id

  def assignments_for_project(project)
  	self.assignments.where(:project_id => project.id)
  end

  def self.in_task_groups
  	Task.all.group_by { |task| task.task_group_ids}
  end

  private
  def handle_task_group
    self.task_groups << TaskGroup.find(self.task_group_id) if self.task_group_id
  end
end
