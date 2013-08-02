require 'spec_helper'

describe "Projects", :js => true do
	include Warden::Test::Helpers

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	describe "#index" do 
				
		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { projects_path }
				let(:user) { @user }
			end
		end

		context "when user is admin" do
			before(:each) do 
				@project = FactoryGirl.create(:project)
				login_as @admin, :scope => :user
				visit projects_path
			end

			it "allows user access to page" do
				page.should have_content "Projects"
			end

			it "displays a list of all projects" do
				page.should have_content @project.name
			end
		end
	end

	describe "creating projects" do
		before(:each) do
			login_as @admin, :scope => :user
			visit projects_path
			within(:css, "#projectList") do
				find('span.formDisplayLink').click
				fill_in "Name", :with => "foobar"
				fill_in "Color", :with => "#fff"
			end
		end

		it "allows admin to create new project" do
			expect do
				click_button "Create Project"
				page.should have_content "Project created"
			end.to change(Project, :count).by 1
		end

		it "allows admin to set deadline for project" do
			deadline = Time.now.strftime("%m/%d/%Y") 
			fill_in "Deadline", :with => deadline
			click_button "Create Project"
			page.should have_content "Project created"
			Project.first.deadline.strftime("%m/%d/%Y").should eq deadline
		end

		it "displays a warning if project creation fails" do
			fill_in "Color", :with => ""
			click_button "Create Project"
			page.should have_content "prohibited this Project from being saved"
		end
	end

	describe "updating projects" do
		before(:each) do
			@project = FactoryGirl.create(:project)
			login_as @admin, :scope => :user
			visit projects_path
			within(:css, "#projectGroup") do
				click_link "edit"
			end			
		end

		it "allows admin to update project info" do
			fill_in "Name", :with => "blah"
			click_button "Update Project"
			page.should have_content "blah"
		end

		it "displays a warning if update fails" do
			fill_in "Name", :with => ""
			click_button "Update Project"
			page.should have_content "prohibited this Project from being saved"
		end
	end

	describe "adding tasks to project" do
		before(:each) do 
			@task = FactoryGirl.create(:task)
			@project = FactoryGirl.create(:project)
			login_as @admin, :scope => :user
		end

		it "allows admin to associate task with project through drag and drop" do
			visit projects_path
			page.execute_script("$('body').prepend($('<div id=\"test_drop_helper\" style=\"position:absolute; top:200px; left:100px; z-index:-1000; width:10px; height:10px;\" ></div>'))")
			target = page.first('#test_drop_helper')			
			task = page.find("li[data-task-assign='#{@task.id}']") 
			task.drag_to(target)
			within(:css, "#projectGroup") do
				page.should have_content @task.name
			end
			@project.tasks.first.should eq @task
		end

		it "allows admin to add a group of tasks to a project" do
			task_group = FactoryGirl.create(:task_group)
			grouped_task_1 = FactoryGirl.create(:task)
			grouped_task_2 = FactoryGirl.create(:task)
			task_group.tasks << grouped_task_2 << grouped_task_1
			visit projects_path
			page.execute_script("$('body').prepend($('<div id=\"test_drop_helper\" style=\"position:absolute; top:200px; left:100px; z-index:-1000; width:10px; height:10px;\" ></div>'))")
			target = page.first('#test_drop_helper')
			drag_group = page.first(".taskGroupName .dragHandle")
			drag_group.drag_to(target)
			within(:css, "#projectGroup") do
				page.should have_content grouped_task_1.name
				page.should have_content grouped_task_2.name
			end
			@project.tasks.should include grouped_task_1
			@project.tasks.should include grouped_task_2
		end
	end

	describe "removing tasks from projects" do
		before(:each) do 
			@task = FactoryGirl.create(:task)
			@project = FactoryGirl.create(:project)
			@project.tasks << @task
			login_as @admin, :scope => :user
			visit projects_path
		end
		it "allows admin to remove tasks" do
			within(:css, "#projectGroup") do 
				click_link "x"
			end
			click_button "OK"
			within(:css, "#projectGroup") do
				page.should_not have_content @task.name
			end
			Project.find(@project.id).tasks.should_not include @task
		end
	end

	describe "#destroy" do
		before(:each) do
			@project = FactoryGirl.create(:project)
			login_as @admin, :scope => :user
			visit projects_path
		end

		it "allows admin to delete project" do
			expect do
				within(:css, "#projectGroup") do 
					click_link "delete"
				end
				click_button "OK"
				page.should have_content "Project deleted"
			end.to change(Project, :count).by -1
		end

		it "associated assignments are deleted when project is deleted" do
			@assignment = FactoryGirl.create(:assignment, :project_id => @project.id)
			expect do
				within(:css, "#projectGroup") do 
					click_link "delete"
				end
				click_button "OK"
				page.should have_content "Project deleted"
			end.to change(Assignment, :count).by -1
		end
	end

	describe "archiving a project" do
		before(:each) do 
			
		end

		it "allows admin to mark project as finished" do
			pending
		end

		it "doesn't display finished projects in project index" do
			pending
		end

		it "displays finished projects in archive" do
			pending
		end

		it "doesn't display unfinished projects in archive" do
			pending
		end
	end

end