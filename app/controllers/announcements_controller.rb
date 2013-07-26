class AnnouncementsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :parse_params, :only => [:create, :update]
	load_and_authorize_resource
	respond_to :json, :js, :html
	
	def index
		@announcements = Announcement.order('created_at')
		@announcement = current_user.announcements.build(:begin_date => Time.now.strftime("%-m/%d/%Y"), :end_date => 1.day.from_now.localtime.strftime("%-m/%d/%Y"))
	end

	def create
		@announcement = current_user.announcements.build(params[:announcement])
		if @announcement.save
			@announcements = Announcement.order('created_at')
			@notice = "Announcement created"
			respond_with @announcements, @notice
		else
			js_alert(@announcement)
		end
	end

	def edit
		@announcement = Announcement.find(params[:id])
	end

	def update
		@announcement = Announcement.find(params[:id])
		if @announcement.update_attributes(params[:announcement])
			flash[:notice] = "Announcement updated"
			js_redirect_to announcements_path
		else
			js_alert(@announcement)
		end
	end

	def destroy
		@announcement = Announcement.find(params[:id])
		if @announcement.destroy
			@notice = "Announcement deleted"
			@announcements = Announcement.order('created_at')
			respond_with @announcments
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