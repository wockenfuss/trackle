class SchedulesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def show
		@cities = City.order('deadline')
		@city = params[:city_id] ? City.find(params[:city_id]) : @cities.first
		@tasks = Task.order('created_at')
		@users = User.non_admin
		@announcement = current_user.announcements.build(:begin_date => Time.now.strftime("%-m/%d/%Y"), :end_date => 1.day.from_now.strftime("%-m/%d/%Y"))
	end
	
end