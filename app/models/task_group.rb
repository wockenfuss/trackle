class TaskGroup < ActiveRecord::Base
	has_and_belongs_to_many :tasks
	
  attr_accessible :name
  validates :name, :presence => true

  def self.name_from_grouped_tasks(group)
  	if group.first.empty?
  		return "Ungrouped Tasks"
  	else
  		return self.find(group.first).first.name
  	end
  end
end
