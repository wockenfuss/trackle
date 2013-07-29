class Task < ActiveRecord::Base
	has_many :assignments
	has_and_belongs_to_many :task_groups
	has_and_belongs_to_many :projects

	validates :name, :presence => true
  attr_accessible :name, :color, :task_group_ids, :project_ids

  def assignments_for_project(project)
  	self.assignments.where(:project_id => project.id)
  end
end
