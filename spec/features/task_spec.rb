require 'spec_helper'

describe Task do
	include Warden::Test::Helpers

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	describe "#index" do 
				
		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { tasks_path }
				let(:user) { @user }
			end
		end

		context "when user is admin" do
			before(:each) do 
				@task = FactoryGirl.create(:task)
				login_as @admin, :scope => :user
				visit tasks_path
			end

			it "displays a list of tasks" do
				page.should have_content @task.name
			end

			it "groups the tasks by task group" do
				pending
			end
		end
	end

	describe "creating tasks" do
		before(:each) do
			login_as @admin, :scope => :user
			visit tasks_path
		end

		it "allows admin user to create tasks" do
			within(:css, "#new_task") do 
				fill_in "Name", :with => "Foo"
				fill_in "Color", :with => "#fff"
			end
			expect do
				click_button "Create Task"
				page.should have_selector("#flash_notice", :text => "Task created")
			end.to change(Task, :count).by 1
		end

		it "displays a warning if task creation fails" do
			click_button "Create Task"
			page.should have_selector("#flash_alert", :text => "Something went wrong")
		end

		it "allows admin to associate tasks with a task group" do
			@task_group = FactoryGirl.create(:task_group)
			visit tasks_path
			within(:css, "#new_task") do 
				fill_in "Name", :with => "Foo"
				fill_in "Color", :with => "#fff"
				select(@task_group.name, :from => 'task_task_group_ids')
			end
			click_button "Create Task"
			page.should have_selector("#flash_notice", :text => "Task created")
			Task.first.task_groups.first.should eq @task_group
		end
	end

	describe "#show", :js => true do
		before(:each) do
			@project = FactoryGirl.create(:project)
			@task = FactoryGirl.create(:task)
			@assignment = FactoryGirl.create(:assignment, 
																				:user_id => @user.id,
																				:project_id => @project.id,
																				:task_id => @task.id)
			login_as @admin, :scope => :user
			visit root_path
		end

		it "displays a list of assignments associated with a given task" do
			page.find(".taskBoxName").click
			within(:css, "div[data-task='#{@task.id}']") do
				page.should have_content @user.name
				page.should have_content @assignment.status
			end
		end
	end

	describe "updating tasks" do
		before(:each) do
			@task = FactoryGirl.create(:task)
			login_as @admin, :scope => :user
			visit edit_task_path @task
		end

		it "allows admin to update task" do
			fill_in "Name", :with => "blab"
			click_button "Update Task"
			page.should have_selector("#flash_notice", :text => "Task updated")
			Task.find(@task.id).name.should eq "blab"
		end

		it "displays a message if update fails" do
			fill_in "Name", :with => ""
			click_button "Update Task"
			page.should have_selector("#flash_alert", :text => "Something went wrong")
		end
	end

	describe "deleting tasks" do
		before(:each) do
			@task = FactoryGirl.create(:task)
			login_as @admin, :scope => :user
			visit tasks_path
		end

		it "allows admin to delete task" do
			expect do
				click_link "delete"
				page.should have_selector("#flash_notice", :text => "Task deleted")
			end.to change(Task, :count).by -1
		end
	end


end