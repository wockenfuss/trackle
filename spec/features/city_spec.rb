require 'spec_helper'

describe "Cities", :js => true do
	include Warden::Test::Helpers

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	describe "#index" do 
				
		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { cities_path }
				let(:user) { @user }
			end
		end

		context "when user is admin" do
			before(:each) do 
				@city = FactoryGirl.create(:city)
				login_as @admin, :scope => :user
				visit cities_path
			end

			it "allows user access to page" do
				page.should have_content "Cities"
			end

			it "displays a list of all cities" do
				page.should have_content @city.name
			end
		end
	end

	describe "creating cities" do
		before(:each) do
			login_as @admin, :scope => :user
			visit cities_path
			fill_in "Name", :with => "foobar"
			fill_in "Color", :with => "#fff"
		end

		it "allows admin to create new city" do
			expect do
				click_button "Create City"
				page.should have_selector("#flash_notice", :text => "City created")
			end.to change(City, :count).by 1
		end

		it "allows admin to set deadline for city" do
			deadline = "01/01/2013" 
			fill_in "Deadline", :with => deadline
			click_button "Create City"
			page.should have_selector("#flash_notice", :text => "City created")
			City.first.deadline.strftime("%m/%d/%Y").should eq deadline
		end

		it "displays a warning if city creation fails" do
			fill_in "Color", :with => ""
			click_button "Create City"
			page.should have_selector("#flash_alert", :text => "Something went wrong")
		end
	end

	describe "updating cities" do
		before(:each) do
			@city = FactoryGirl.create(:city)
			login_as @admin, :scope => :user
			visit edit_city_path @city
		end

		it "allows admin to update city info" do
			fill_in "Name", :with => "blah"
			click_button "Update City"
			page.should have_selector("#flash_notice", :text => "City updated")
		end

		it "displays a warning if update fails" do
			fill_in "Name", :with => ""
			click_button "Update City"
			page.should have_selector("#flash_alert", :text => "Something went wrong")
		end
	end

	describe "#destroy" do
		before(:each) do
			@city = FactoryGirl.create(:city)
			login_as @admin, :scope => :user
			visit cities_path
		end

		it "allows admin to delete city" do
			expect do
				click_link "delete"
				click_button "OK"
			end.to change(City, :count).by -1
		end

		it "associated assignments are deleted when city is deleted" do
			@assignment = FactoryGirl.create(:assignment, :city_id => @city.id)
			expect do
				click_link "delete"
				click_button "OK"
			end.to change(Assignment, :count).by -1
		end
	end

end