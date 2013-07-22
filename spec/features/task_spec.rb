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
		end
	end

	describe "creating tasks" do
		before(:each) do
			login_as @admin, :scope => :user
			visit tasks_path
		end

		it "allows admin user to create tasks" do
			fill_in "Name", :with => "Foo"
			fill_in "Color", :with => "#fff"
			expect do
				click_button "Create Task"
				page.should have_selector("#flash_notice", :text => "Task created")
			end.to change(Task, :count).by 1
		end

		it "displays a warning if task creation fails" do
			click_button "Create Task"
			page.should have_selector("#flash_alert", :text => "Something went wrong")
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