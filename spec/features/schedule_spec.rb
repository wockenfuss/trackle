require 'spec_helper'

describe Schedule do
	include Warden::Test::Helpers

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	describe "#show" do
		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { root_path }
				let(:user) { @user }
			end
		end

		context "when user is admin" do
			before(:each) do 
				login_as @admin, :scope => :user
				visit root_path
			end

			it "allows user access to page" do
				page.should have_content @admin.email
			end

			it "displays list of non-admin users" do
				page.should have_content @user.name
				page.should_not have_content @admin.name
			end

			it "displays a list of tasks" do
				@city = FactoryGirl.create(:city)
				@task = FactoryGirl.create(:task)
				visit root_path
				page.should have_content @task.name
			end

			it "displays management options for other resources" do
				page.should have_link "Manage"
			end

		end
	end

end