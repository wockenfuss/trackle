class UsersController < ApplicationController

	def index
		@users = User.all
		@user = User.new
	end

	def show 
		@user = User.find(params[:id])
	end

	def create
		@user = User.create(params[:user])
		if @user.save
			redirect_to users_path, :notice => "New user created"
		else
			render users_path, :error => "Something went wrong"
		end
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			redirect_to users_path, :notice => "User deleted"
		end
	end
end
