class Task < ActiveRecord::Base
	has_many :assignments
	validates :name, :presence => true
  attr_accessible :name, :color

  def assignments_for_project(project)
  	self.assignments.where(:project_id => project.id)
  end
end
