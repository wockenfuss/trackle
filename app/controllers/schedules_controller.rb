class SchedulesController < ApplicationController

	def show
		@city = City.order('deadline').first
		@tasks = Task.all
		@users = User.all
	end
	
end