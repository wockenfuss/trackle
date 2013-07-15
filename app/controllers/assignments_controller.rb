class AssignmentsController < ApplicationController
	respond_to :js, :html, :json

	def new
		@assignment = Assignment.new(params[:assignment])
		respond_with @assignment
	end

	def create
		@assignment = Assignment.new(params[:assignment])
		if @assignment.save
			@color = @assignment.user.current_city_color
			respond_with(@assignment, @color)
		else
			respond_with( {:error => "error"}, :location => nil)
		end
	end

	def update
		@assignment = Assignment.find(params[:id])
		@user = @assignment.user
		if @assignment.update_attributes(params[:assignment])
			@assignment = @user.current_assignment
			@queue = @user.queued
			respond_with @assignment, @queued
		else
			# handle error
		end
	end

	def destroy 
		@assignment = Assignment.find(params[:id])
		@user = @assignment.user
		if @assignment.destroy
			respond_with @user
		end
	end
end