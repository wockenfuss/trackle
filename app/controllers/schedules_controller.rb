class SchedulesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def show
		@projects = Project.order('deadline')
		@project = params[:project_id] ? Project.find(params[:project_id]) : @projects.first
		@tasks = Task.order('created_at')
		@users = User.non_admin
		@announcements = Announcement.current
		if params[:time_zone]
			Time.zone = params[:time_zone]
		end
	end
	
end