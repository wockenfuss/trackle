class Assignment < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  validates :queue_index, :presence => true

  has_many :comments, :dependent => :destroy
  accepts_nested_attributes_for :comments, :allow_destroy => true, reject_if: proc { |attributes| attributes['content'].blank? }
	belongs_to :user
	belongs_to :task
	belongs_to :city

  attr_accessible :amount_completed, :completed_at, :deadline, 
                  :duration, :hold, :started_at, 
                  :user_id, :task_id, :city_id, :comments_attributes, 
                  :queue_index, :resumed_at, :elapsed_time
  before_save :check_elapsed_time

  def status
  	if completed?
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

  def elapsed
    return 0.0 if !self.resumed_at
    return self.elapsed_time.to_f if !!self.hold
    Time.now - self.resumed_at + self.elapsed_time
  end

  private
  def check_elapsed_time
    if self.hold == true || !!self.completed_at
      self.elapsed_time = Time.now - self.resumed_at + self.elapsed_time
    end
  end

end
