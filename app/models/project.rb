class Project < ActiveRecord::Base
	has_many :assignments, :dependent => :destroy
	has_and_belongs_to_many :tasks

	validates :name, :presence => true
	validates :color, :presence => true
  attr_accessible :deadline, :name, :color, :task_ids, :completed_at
end
