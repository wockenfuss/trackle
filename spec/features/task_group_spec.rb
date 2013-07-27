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
				let(:path) { tasks_path }
				let(:user) { @user }
			end
		end

		context "for admin users" do
			before(:each) do
				login_as @admin, :scope => :user
				visit tasks_path
			end

			it "allows admin to create new project group", :js => true do
				within(:css, "#new_task_group") do
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
				visit tasks_path
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
				pending
			end
		end
	end

	describe "editing task groups", :js => true do
		before(:each) { @task_group = FactoryGirl.create(:task_group) }

		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { edit_task_group_path(@task_group) }
				let(:user) { @user }
			end
		end

		context "for authorized users" do
			before(:each) do
				login_as @admin, :scope => :user
				visit edit_task_group_path @task_group
			end

			it "allows admin to edit task group" do
				fill_in "Name", :with => "Foo"
				click_button "Update Task group"
				page.should have_content "Task Group updated"
				TaskGroup.find(@task_group.id).name.should eq "Foo"
			end
		end

	end
end