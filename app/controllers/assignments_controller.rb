class AssignmentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource  
	before_filter :parse_params, :only => [:create, :update]

	respond_to :js, :html, :json

	def new
		@assignment = Assignment.new(params[:assignment])
		@queue_index = @assignment.user.assignments.count + 1
		# @comments = Comment.new
		@assignment.comments.build
		respond_with @assignment, @comment, @queue_index
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
			@on_hold = @user.on_hold
			respond_to do |format|
	      format.js
	      format.json { render :json => { :assignment => Assignment.find(params[:id])} }
	    end
		else
			puts "error"
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

	private
	def parse_params
		parse_dates(params[:assignment]) if params[:assignment]
	end
end