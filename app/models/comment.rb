class Comment < ActiveRecord::Base
	validates :content, :presence => true

	belongs_to :user
	belongs_to :assignment
  attr_accessible :assignment_id, :content, :user_id
end
