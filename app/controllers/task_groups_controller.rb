class TaskGroupsController < ApplicationController
	before_filter :authenticate_user!

	load_and_authorize_resource
	respond_to :html, :js, :json

	def create
		@task_group = TaskGroup.new(params[:task_group])
		if @task_group.save
			@task = Task.new
			@task_groups = TaskGroup.order('LOWER(name)')
			@grouped_tasks = Task.in_task_groups
			@notice = "Task Group created"
		else
			js_alert(@task_group)
		end
	end

	def show
		@task_group = TaskGroup.find(params[:id])
	end

	def edit
		@task_group = TaskGroup.find(params[:id])
	end

	def update
		if params[:commit] != 'Cancel'
			@task_group = TaskGroup.find(params[:id])
			unless @task_group.update_attributes(params[:task_group])
				js_alert(@task_group) and return
			end
		end
		@task_groups = TaskGroup.order('LOWER(name)')
		@task_group = TaskGroup.new
		@grouped_tasks = Task.in_task_groups
		@task = Task.new
	end

	def destroy
		@task_group = TaskGroup.find(params[:id])
		if @task_group.destroy
			@task = Task.new
			@task_groups = TaskGroup.order('LOWER(name)')
			@notice = "Task Group deleted"
			@grouped_tasks = Task.in_task_groups
		end
	end

end