class User < ActiveRecord::Base

	validates :name, :presence => true
  attr_accessible :absent, :available, :email, :name
end
