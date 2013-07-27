require 'spec_helper'

describe Assignment, :js => true do
	include Warden::Test::Helpers

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	describe "creating assignments" do

		context "when user is admin" do
			before(:each) do 
				@project = FactoryGirl.create(:project)
				@task = FactoryGirl.create(:task)
				login_as @admin, :scope => :user
				visit root_path
				#create phantom target so capybara will drag fully onto target
				page.execute_script("$('##{@user.id}').prepend($('<div id=\"test_drop_helper\" style=\"position:absolute; top:150px; left:300px; z-index:-1000; width:10px; height:10px;\" ></div>'))")
  			task = page.find("div[data-task='#{@task.id}']") 
  			target = page.first('#test_drop_helper')
  			task.drag_to(target)
			end

			it "allows admin to create assignment by drag and drop" do
  			expect do
  				click_button("Assign task")
  				visit root_path
  			end.to change(Assignment, :count).by 1
			end

			it "allows admin to set duration for assignment" do
				fill_in "Duration", :with => 2
				click_button("Assign task")
  			visit root_path
  			@user.assignments.first.duration.should eq 2
			end

			it "allows admin to set a deadline for the assignment" do
				deadline = "01/01/2013"
				fill_in("Deadline", :with => deadline)
				click_button("Assign task")
  			visit root_path
  			@user.assignments.first.deadline.strftime("%m/%d/%Y").should eq deadline
			end

		end
	end

	describe "deleting assignments" do
		before(:each) do
				@project = FactoryGirl.create(:project)
				@task = FactoryGirl.create(:task)
				@assignment = FactoryGirl.create(:assignment, 
																					:project_id => @project.id,
																					:task_id => @task.id,
																					:user_id => @user.id)
				login_as @admin, :scope => :user
				visit root_path
		end

		it "allows admin to delete assignments" do
			page.find("div[data-user='#{@user.id}']").click
			page.find("a[data-method='delete']").click
			expect do
				click_button "OK" 
				visit root_path
			end.to change(Assignment, :count).by -1
		end


	end

	describe "updating assignments" do
		before(:each) do
			# @project = FactoryGirl.create(:project)
			# @task = FactoryGirl.create(:task)
			# @assignment = FactoryGirl.create(:assignment, 
			# 																	:user_id => @user.id,
			# 																	:task_id => @task.id,
			# 																	:project_id => @project.id)
			# login_as @user, :scope => :user
			# visit user_path(@user)
		end

		it "allows a user to mark an assignment as started" do
			pending
			# click_button "Begin"
			# page.should have_content "in progress"
		end

		it "allows a user to mark an assignment as paused" do
			pending
		end

		it "allows a user to resume a paused assignment" do
			pending
		end

		it "does not allow a paused assignment to resume if another assignment is in progress" do
			pending
		end

		it "allows a user to mark an in progress assignment as completed" do
			pending
		end
	end

end