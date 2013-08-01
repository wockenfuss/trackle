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
		@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}
	end

	def show
		@project = Project.find(params[:id])
		respond_with @project
	end

	def create
		@project = Project.create(params[:project])
		if @project.save
			@project = Project.new
			@projects = Project.incomplete
			@notice = "Project created"
			respond_with @project, @projects, @notice
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
		respond_with @projects, @project	
	end

	def destroy
		@project = Project.find(params[:id])
		if @project.destroy
			@notice = "Project deleted"
			@projects = Project.incomplete
			respond_with @notice, @projects
		end
	end

	private
	def parse_params
		parse_dates(params[:project]) if params[:project]
	end
end