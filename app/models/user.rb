class User < ActiveRecord::Base
	has_many :assignments
	has_many :tasks, :through => :assignments
	validates :name, :presence => true
  attr_accessible :absent, :available, :email, :name
end
