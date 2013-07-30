class TaskGroupsController < ApplicationController
	before_filter :authenticate_user!

	load_and_authorize_resource
	respond_to :html, :js, :json

	def create
		@task_group = TaskGroup.new(params[:task_group])
		if @task_group.save
			@task = Task.new
			@task_groups = TaskGroup.order('LOWER(name)')
			@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}
			@notice = "Task Group created"
			respond_with @task_groups, @notice
		else
			js_alert(@task_group)
		end
	end

	def show
		@task_group = TaskGroup.find(params[:id])
		respond_with @task_group
	end

	def edit
		@task_group = TaskGroup.find(params[:id])
	end

	def update
		if params[:commit] != 'Cancel'
			@task_group = TaskGroup.find(params[:id])
			if params[:task_id]
				@task_group.tasks << Task.find(params[:task_id])
			else
				unless @task_group.update_attributes(params[:task_group])
					js_alert(@task_group) and return
				end
			end
			
		end
		@task_groups = TaskGroup.order('LOWER(name)')
		@task_group = TaskGroup.new
		@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}		
		@task = Task.new
		respond_with @task_groups, @task_group	
	end

	def destroy
		@task_group = TaskGroup.find(params[:id])
		if @task_group.destroy
			@task = Task.new
			@task_groups = TaskGroup.all
			@notice = "Task Group deleted"
			@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}		
			respond_with @task_groups, @notice, @task
		end
	end

end