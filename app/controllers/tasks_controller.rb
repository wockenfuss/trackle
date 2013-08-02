class TasksController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	respond_to :html, :js, :json

	def index
		@task = Task.find(params[:task_id])
		@project = Project.find(params[:project_id])
	end

	def show
		if params[:project_id]
			@project = Project.find(params[:project_id])
		end
	end

	def create
		@task = Task.new(params[:task])
		if @task.save
			@task = Task.new
			@task_groups = TaskGroup.order('LOWER(name)')
			@grouped_tasks = Task.in_task_groups
			@notice = "Task created"
		else
			js_alert(@task)
		end
	end

	def edit
		@task = Task.find(params[:id])
	end

	def update
		if params[:commit] != 'Cancel'
			@task = Task.find(params[:id])
			unless @task.update_attributes(params[:task])
				js_alert(@task) and return
			end				
		end
		@task_groups = TaskGroup.order('LOWER(name)')
		@grouped_tasks = Task.in_task_groups
		@task = Task.new
		@project = Project.new
		@projects = Project.incomplete
	end

	def destroy
		@task = Task.find(params[:id])
		if @task.destroy
			@task = Task.new
			@task_groups = TaskGroup.order('LOWER(name)')
			@grouped_tasks = Task.in_task_groups
			@project = Project.new
			@projects = Project.incomplete
			@notice = "Task deleted"
		end
	end

end