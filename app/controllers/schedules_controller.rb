class SchedulesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def show
		@projects = Project.where('completed_at is NULL').order('deadline')
		@project = params[:project_id] ? Project.find(params[:project_id]) : @projects.first
		@users = User.non_admin
		@announcements = Announcement.current
		if params[:time_zone]
			Time.zone = params[:time_zone]
		end
	end
	
end