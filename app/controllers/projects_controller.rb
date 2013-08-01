class ProjectsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	before_filter :parse_params, :only => [:create, :update]
	respond_to :js, :html, :json

	def index
		@projects = Project.where('completed_at is NULL').order('updated_at desc')
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
			@projects = Project.where('completed_at is NULL').order('updated_at desc')
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
		if params[:remove]
			@project.tasks.delete(Task.find(params[:remove]))
		elsif params[:task_id]
			@task = Task.find(params[:task_id])
			@project.tasks << @task unless @project.tasks.include? @task
		elsif params[:completed]
			if params[:completed] == "true"
				@project.update_attributes(:completed_at => Time.now)
				flash[:notice] = "Project completed"
				js_redirect_to archives_path and return
			else
				@project.update_attributes(:completed_at => nil)
				flash[:notice] = "Project marked incomplete"
				js_redirect_to projects_path and return
			end
		elsif params[:commit] != 'Cancel'
			unless @project.update_attributes(params[:project])
				js_alert(@project) and return
			end
		end
		@projects = Project.where('completed_at is NULL').order('updated_at desc')
		@project = Project.new
		respond_with @projects, @project	
	end

	def destroy
		@project = Project.find(params[:id])
		if @project.destroy
			@notice = "Project deleted"
			@projects = Project.where('completed_at is NULL').order('updated_at desc')
			respond_with @notice, @projects
		end
	end

	private
	def parse_params
		parse_dates(params[:project]) if params[:project]
	end
end