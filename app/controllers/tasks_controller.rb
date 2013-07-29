class TasksController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	respond_to :html, :js, :json

	def index
		@task = Task.find(params[:task_id])
		@project = Project.find(params[:project_id])
		respond_with @task, @project
		# @task = Task.new
		# @task_groups = TaskGroup.order('LOWER(name)')
		# @grouped_tasks = Task.all.group_by { |task| task.task_group_ids}
		# @tasks = Task.all
		# respond_with @tasks, @task
	end

	def show
		if params[:project_id]
			@task = Task.find(params[:id])
			@project = Project.find(params[:project_id])
			respond_with @task, @project
		else

		end
	end

	def create
		@task = Task.create(params[:task])
		if @task.save
			@task = Task.new
			@task_groups = TaskGroup.order('LOWER(name)')
			@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}
			respond_with @task, @task_groups, @grouped_tasks
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
		@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}		
		@task = Task.new
		respond_with @task_groups, @task_group, @task	
	end

	def destroy
		@task = Task.find(params[:id])
		if @task.destroy
			@task = Task.new
			@task_groups = TaskGroup.order('LOWER(name)')
			@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}
			respond_with @task, @task_groups, @grouped_tasks
		end
	end

end