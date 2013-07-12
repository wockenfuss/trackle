class SchedulesController < ApplicationController

	def show
		@cities = City.order('deadline')
		@city = params[:city_id] ? City.find(params[:city_id]) : @cities.first
		@tasks = Task.all
		@users = User.all
	end
	
end