class TasksController < ApplicationController
	respond_to :html, :js, :json

	def index
		@task = Task.new
		@tasks = Task.all
	end

	def create
		@task = Task.create(params[:task])
		if @task.save
			redirect_to tasks_path, :notice => "Task created"
		else
			render @tasks, :error => "Something went wrong"
		end
	end

end