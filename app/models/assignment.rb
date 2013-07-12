class Assignment < ActiveRecord::Base
	belongs_to :user
	belongs_to :task
	belongs_to :city

  attr_accessible :amount_completed, :completed_at, :deadline, :duration, :hold, :paused_at, :started_at, :user_id, :task_id, :city_id

  def assignments_for_city(city)
  	Assignment.where(:city_id => city.id)
  end
  
end
