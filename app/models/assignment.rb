class Assignment < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  validates :queue_index, :presence => true

  has_many :comments, :dependent => :destroy
  accepts_nested_attributes_for :comments, :allow_destroy => true, reject_if: proc { |attributes| attributes['content'].blank? }
	belongs_to :user
	belongs_to :task
	belongs_to :project

  attr_accessible :amount_completed, :completed_at, :deadline, 
                  :duration, :hold, :started_at, 
                  :user_id, :task_id, :project_id, :comments_attributes, 
                  :queue_index, :resumed_at, :elapsed_time
  before_save :check_elapsed_time
  before_save :update_queue

  def status
  	if self.completed_at?
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

  def elapsed_time
    return 0.0 if !self.resumed_at
    return read_attribute(:elapsed_time).to_f if self.hold?
    Time.now - self.resumed_at + read_attribute(:elapsed_time)
  end

  # def project_completed?
  #   self.
  # end

  private
  def check_elapsed_time
    if self.hold == true || !!self.completed_at
      self.elapsed_time = Time.now - self.resumed_at + read_attribute(:elapsed_time)
    end
  end

  def update_queue
    if self.completed_at?
      if self.queue_index != 0
        self.update_attributes(:queue_index => 0) 
        self.user.incomplete_assignments.each do |assignment|
          assignment.queue_index -= 1
          assignment.save
        end
      end
    end
  end
end
