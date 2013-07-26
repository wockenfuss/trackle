class AssignmentsController < ApplicationController
  load_and_authorize_resource  
  before_filter :authenticate_user!
	before_filter :parse_params, :only => [:create, :update]
	before_filter :check_timestamps, :only => [:update]
	respond_to :js, :html, :json

	def new
		@assignment = Assignment.new(params[:assignment])
		@queue_index = @assignment.user.assignments.count + 1
		@assignment.comments.build
		respond_with @assignment, @comment, @queue_index
	end

	def create
		@assignment = Assignment.new(params[:assignment])
		if @assignment.save
			respond_with(@assignment)
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

	def check_timestamps
    params[:assignment][:started_at] = Time.now if params[:assignment][:started_at] == "true"
    params[:assignment][:resumed_at] = Time.now if params[:assignment][:resumed_at] == "true"
    params[:assignment][:completed_at] = Time.now if params[:assignment][:completed_at] == "true"
  end


end