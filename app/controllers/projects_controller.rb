class ProjectsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	before_filter :parse_params, :only => [:create, :update]

	def index
		@projects = Project.all
		@project = Project.new
		@task = Task.new
		@task_group = TaskGroup.new
		@task_groups = TaskGroup.order('LOWER(name)')
		@grouped_tasks = Task.all.group_by { |task| task.task_group_ids}
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])
		if @project.update_attributes(params[:project])
			redirect_to projects_path, :notice => "Project updated"
		else 
			redirect_to edit_project_path(@project), :alert => "Something went wrong"
		end
	end

	def create
		@project = Project.create(params[:project])
		if @project.save
			redirect_to projects_path, :notice => "Project created"
		else
			redirect_to projects_path, :alert => "Something went wrong"
		end
	end

	def destroy
		@project = Project.find(params[:id])
		if @project.destroy
			redirect_to projects_path, :notice => "Project deleted"
		end
	end

	private
	def parse_params
		parse_dates(params[:project]) if params[:project]
	end
end