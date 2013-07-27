class TaskGroupsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	respond_to :html, :js, :json

	def create
		@task_group = TaskGroup.new(params[:task_group])
		if @task_group.save
			@task_groups = TaskGroup.all
			@notice = "Task Group created"
			respond_with @task_groups, @notice
		else
			js_alert(@task_group)
		end
	end

	def edit
		@task_group = TaskGroup.find(params[:id])
	end

	def update
		@task_group = TaskGroup.find(params[:id])
		if @task_group.update_attributes(params[:task_group])
			flash[:notice] = "Task Group updated"
			js_redirect_to tasks_path
		else
			js_alert(@task_group)
		end
	end

	def destroy
		@task_group = TaskGroup.find(params[:id])
		if @task_group.destroy
			@task_groups = TaskGroup.all
			@notice = "Task Group deleted"
			respond_with @task_groups, @notice
		end
	end
end