class AnnouncementsController < ApplicationController
	before_filter :parse_params, :only => [:create, :update]

	def create
		@announcement = current_user.announcements.build(params[:announcement])
		if @announcement.save
			@notice = "Announcement created"
		else
			js_alert(@announcement)
		end
	end


	private
	def parse_params
		begin_date = params[:announcement][:begin_date] || ""
		end_date = params[:announcement][:end_date] || ""
		params[:announcement][:begin_date] = parsed_date(begin_date) unless begin_date == ""
		params[:announcement][:end_date] = parsed_date(end_date) unless end_date == ""
	end
end