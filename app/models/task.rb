class Task < ActiveRecord::Base
	has_many :assignments
	# has_and_belongs_to_many :task_groups

	validates :name, :presence => true
  attr_accessible :name, :color

  def assignments_for_project(project)
  	self.assignments.where(:project_id => project.id)
  end
end
