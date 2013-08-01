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

		it "allows admin to associate task with project" do
			pending
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

end