require 'spec_helper'

describe Announcement do 
	include Warden::Test::Helpers
		
	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	after(:each) { back_to_the_present }

	describe "#index" do

		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { announcements_path }
				let(:user) { @user }
			end
		end

		context "when user is admin" do
			let(:announcement) { Announcement.new }
			it "displays a list of current announcements" do
				login_as @admin, :scope => :user
				visit announcements_path
				page.should have_content announcement.subject
			end
		end

	end

	describe "#create", :js => true do
		before(:each) do
			login_as @admin, :scope => :user
			visit announcements_path
			find('span').click
		end
		it "allows admin to create an announcement" do
			fill_in "Subject", :with => "foo"
			fill_in "Content", :with => "bar"
			expect do
				click_button "Create Announcement"
				visit announcements_path
			end.to change(Announcement, :count).by 1
		end

		it "displays a notice when announcement is saved" do
			fill_in "Subject", :with => "foo"
			fill_in "Content", :with => "bar"
			click_button "Create Announcement"
			page.should have_content "Announcement created"
		end

		it "displays an error alert if announcement is not saved" do
			click_button "Create Announcement"
			page.should have_content "errors prohibited this Announcement from being saved"		
		end
	end

	describe "#edit" do

		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { announcements_path }
				let(:user) { @user }
			end
		end

		context "when user is admin" do

			before(:each) do
				@announcement = FactoryGirl.create(:announcement)
				login_as @admin, :scope => :user
				visit edit_announcement_path(@announcement)
			end

			it "allows user to update the announcement" do
				fill_in "Subject", :with => "foo"
				click_button "Update Announcement"
				Announcement.find(@announcement.id).subject.should eq "foo"
			end

			it "displays a confirmation when announcement is updated", :js => true do
				fill_in "Subject", :with => "foo"
				click_button "Update Announcement"
				page.should have_content "Announcement updated"
			end

			it "displays a warning when update fails", :js => true do
				fill_in "Subject", :with => ""
				click_button "Update Announcement"
				page.should have_content "error prohibited this Announcement"
			end
		end

	end

	describe "#destroy", :js => true do
		before(:each) do
			@announcement = FactoryGirl.create(:announcement)
			login_as @admin, :scope => :user
			visit announcements_path(@announcement)
		end

		it "allows admin to delete announcement" do
			expect do
				click_link "Delete"
				click_button "OK"
				page.should have_selector("#alerts", :text => "Announcement deleted")
			end.to change(Announcement, :count).by -1
		end

	end

	describe "announcement display", :js => true do
		before(:each) do
			time_travel_to "11:00"
			@announcement = FactoryGirl.create(:announcement)
		end

		it "displays current announcement to users" do
			time_travel_to "23:59"
			login_as @user, :scope => :user
			visit user_path @user
			page.should have_content @announcement.subject
		end

		it "doesn't display expired announcements" do
			time_travel_to "24:01"
			login_as @user, :scope => :user
			visit user_path @user
			page.should_not have_content @announcement.subject
		end
	end

end