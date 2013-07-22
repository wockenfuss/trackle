class TasksController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	respond_to :html, :js, :json

	def index
		@task = Task.new
		@tasks = Task.all
		respond_with @tasks, @task
	end

	# def show
	# 	@task = Task.find(params[:id])
	# 	@city = City.find(params[:city_id])
	# end

	def create
		@task = Task.create(params[:task])
		if @task.save
			redirect_to tasks_path, :notice => "Task created"
		else
			redirect_to tasks_path, :alert => "Something went wrong"
		end
	end

	def edit
		@task = Task.find(params[:id])
	end

	def update
		@task = Task.find(params[:id])
		if @task.update_attributes(params[:task])
			redirect_to tasks_path, :notice => "Task updated"
		else
			redirect_to edit_task_path(@task), :alert => "Something went wrong"
		end
	end

	def destroy
		@task = Task.find(params[:id])
		if @task.destroy
			redirect_to tasks_path, :notice => "Task deleted"
		end
	end

end