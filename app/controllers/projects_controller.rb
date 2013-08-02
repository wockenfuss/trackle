class ProjectsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	before_filter :parse_params, :only => [:create, :update]
	respond_to :js, :html, :json

	def index
		@projects = Project.incomplete
		@project = Project.new
		@task = Task.new
		@task_group = TaskGroup.new
		@task_groups = TaskGroup.order('LOWER(name)')
		@grouped_tasks = Task.in_task_groups
	end

	def show
		@project = Project.find(params[:id])
	end

	def create
		@project = Project.new(params[:project])
		if @project.save
			@project = Project.new
			@projects = Project.incomplete
			@notice = "Project created"
		else
			js_alert(@project)
		end
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])
		if params[:commit] != 'Cancel'
			if @project.update_attributes(params[:project])
				if @project.completed
					flash[:notice] = @project.update_notice
					js_redirect_to @project.redirect_path and return
				end
			else
				js_alert(@project) and return
			end
		end
		@projects = Project.incomplete
		@project = Project.new
	end

	def destroy
		@project = Project.find(params[:id])
		if @project.destroy
			@notice = "Project deleted"
			@projects = Project.incomplete
		end
	end

	private
	def parse_params
		parse_dates(params[:project]) if params[:project]
	end
end