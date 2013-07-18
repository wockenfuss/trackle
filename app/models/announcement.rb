class Announcement < ActiveRecord::Base

	belongs_to :user

	validates :content, :presence => true
	validates :user_id, :presence => true
	validates :subject, :presence => true
	validates :end_date, :presence => true


  attr_accessible :begin_date, :content, :end_date, :subject, :user_id

  def self.current
  	Announcement.where('end_date > ?', Time.now)
  end
end
