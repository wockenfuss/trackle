class Assignment < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  has_many :comments, :dependent => :destroy
  accepts_nested_attributes_for :comments, :allow_destroy => true, reject_if: proc { |attributes| attributes['content'].blank? }
	belongs_to :user
	belongs_to :task
	belongs_to :city

  attr_accessible :amount_completed, :completed_at, :deadline, :duration, :hold, :paused_at, :started_at, :user_id, :task_id, :city_id, :comments_attributes

  def assignments_for_city(city)
  	Assignment.where(:city_id => city.id)
  end

  def status
  	if completed_at
  		return "completed"
  	else
  		if started_at
	  		if !hold
					return "in progress"  			
	  		else
	  			return "on hold"
	  		end
	  	else
	  		return "not yet begun"
	  	end
  	end
  end

  def completed?
  	return !!completed_at
  end

  def has_comment?
    result = false
    self.comments.each do |comment|
      result = comment.content != ""
    end
    result
  end
end
