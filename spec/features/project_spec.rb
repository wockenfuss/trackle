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
			fill_in "Name", :with => "foobar"
			fill_in "Color", :with => "#fff"
		end

		it "allows admin to create new project" do
			expect do
				click_button "Create Project"
				page.should have_selector("#flash_notice", :text => "Project created")
			end.to change(Project, :count).by 1
		end

		it "allows admin to set deadline for project" do
			deadline = Time.now.strftime("%m/%d/%Y") 
			fill_in "Deadline", :with => deadline
			click_button "Create Project"
			page.should have_selector("#flash_notice", :text => "Project created")
			Project.first.deadline.strftime("%m/%d/%Y").should eq deadline
		end

		it "allows admin to associate task with project" do
			pending
		end

		it "displays a warning if project creation fails" do
			fill_in "Color", :with => ""
			click_button "Create Project"
			page.should have_selector("#flash_alert", :text => "Something went wrong")
		end
	end

	describe "updating projects" do
		before(:each) do
			@project = FactoryGirl.create(:project)
			login_as @admin, :scope => :user
			visit edit_project_path @project
		end

		it "allows admin to update project info" do
			fill_in "Name", :with => "blah"
			click_button "Update Project"
			page.should have_selector("#flash_notice", :text => "Project updated")
		end

		it "displays a warning if update fails" do
			fill_in "Name", :with => ""
			click_button "Update Project"
			page.should have_selector("#flash_alert", :text => "Something went wrong")
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
				click_link "delete"
				click_button "OK"
			end.to change(Project, :count).by -1
		end

		it "associated assignments are deleted when project is deleted" do
			@assignment = FactoryGirl.create(:assignment, :project_id => @project.id)
			expect do
				click_link "delete"
				click_button "OK"
			end.to change(Assignment, :count).by -1
		end
	end

end