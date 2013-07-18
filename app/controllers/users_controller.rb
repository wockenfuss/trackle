class UsersController < ApplicationController
	before_filter :authenticate_user!, :except => [:create, :new]
	load_and_authorize_resource
	respond_to :js, :json, :html

	def index
		@users = User.all
		@user = User.new
	end

	def show 
		@user = User.find(params[:id])
		@assignment = @user.current_assignment
		@on_hold = @user.on_hold
		@queue = @user.queued
		@location = params[:appendLocation] if params[:appendLocation]
		@announcements = Announcement.current
		respond_with @user, @location
	end

	def create
		@user = User.create(params[:user])
		if @user.save
			redirect_to users_path, :notice => "New user created"
		else
			render users_path, :error => "Something went wrong"
		end
	end

	def update
		@user = User.find(params[:id])
		@user.update_admin(params)
		if @user.update_attributes(params[:user])
			redirect_to users_path, :notice => "User updated"
		else
			render @user, :error => "Something went wrong"
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			redirect_to users_path, :notice => "User deleted"
		end
	end
end
