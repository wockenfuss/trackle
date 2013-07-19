class AnnouncementsController < ApplicationController
	before_filter :parse_params, :only => [:create, :update]
	load_and_authorize_resource
	respond_to :json, :js, :html

	def index
		@announcements = Announcement.order('created_at')
	end

	def create
		@announcement = current_user.announcements.build(params[:announcement])
		if @announcement.save
			@notice = "Announcement created"
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