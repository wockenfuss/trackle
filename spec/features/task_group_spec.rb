require 'spec_helper'

describe TaskGroup do
	include Warden::Test::Helpers

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	describe "creating task groups" do

		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { projects_path }
				let(:user) { @user }
			end
		end

		context "for admin users" do
			before(:each) do
				login_as @admin, :scope => :user
				visit projects_path
			end

			it "allows admin to create new project group", :js => true do
				within(:css, "#taskGroupList") do
					find('span.formDisplayLink').click
					fill_in "Name", :with => "Foo"
				end
				expect do
					click_button "Create Task group"
					page.should have_content "Task Group created"
				end.to change(TaskGroup, :count).by 1
			end
		end
	end

	describe "deleting task groups", :js => true do
		context "when user is authorized" do
			before(:each) do
				@task_group = FactoryGirl.create(:task_group)
				login_as @admin, :scope => :user
				visit projects_path
			end

			it "allows admin to delete task group" do
				expect do
					within(:css, "#taskGroupIndex") do
						click_link "delete"
					end
					click_button("OK")
					page.should have_content "Task Group deleted"
				end.to change(TaskGroup, :count).by -1
			end

			it "doesn't delete associated tasks" do
				@task = FactoryGirl.create(:task)
				@task_group.tasks << @task
				within(:css, "#taskGroupIndex") do
					click_link "delete"
				end
				click_button("OK")
				page.should have_content "Task Group deleted"
				Task.count.should eq 1
			end
		end
	end

	describe "editing task groups", :js => true do
		before(:each) { @task_group = FactoryGirl.create(:task_group) }

		context "for authorized users" do
			before(:each) do
				login_as @admin, :scope => :user
				visit projects_path
				within(:css, "#taskGroupIndex") do
					click_link "edit"
				end
			end

			it "allows admin to edit task group" do
				within(:css, "#taskGroupList") do
					fill_in "Name", :with => "Foo"
					click_button "Update Task group"
				end
				page.should have_content "Foo"
			end
		end

	end
end