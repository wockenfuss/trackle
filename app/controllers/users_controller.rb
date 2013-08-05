class UsersController < ApplicationController
	before_filter :authenticate_user!, :except => [:create, :new]
	load_and_authorize_resource
	before_filter :check_for_cancel
	respond_to :js, :json, :html

	def index
		@users = User.non_admin
		@admins = User.admin
	end

	def show 
		@user = User.find(params[:id])
		@location = params[:appendLocation] if params[:appendLocation]
		@announcements = Announcement.current
		respond_with @user, @location
	end

	def update
		@user = User.find(params[:id])
		@user.update_admin(params)
		if @user.update_attributes(params[:user])
			redirect_to users_path, :notice => "User updated"
		else
			redirect_to edit_user_path(@user), :alert => "Something went wrong"
		end
	end

	def edit
		@user = User.find(params[:id])
		@assignments = @user.assignments.where('completed_at is NULL')
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			redirect_to users_path, :notice => "User deleted"
		end
	end

	private
	def check_for_cancel
		if params[:commit] == 'Cancel'
	 		redirect_to users_path
		end
	end
end
