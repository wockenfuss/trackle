class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :assignment
  attr_accessible :assignment_id, :content, :user_id
end
