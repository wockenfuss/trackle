require 'spec_helper.rb'

describe User do
	include Warden::Test::Helpers

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@admin = FactoryGirl.create(:user)
		@admin.add_role(:admin)
	end

	describe "#index" do 
				
		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:path) { users_path }
				let(:user) { @user }
			end
		end

		context "when user is admin" do
			before(:each) do 
				login_as @admin, :scope => :user
				visit users_path
			end

			it "allows user access to page" do
				page.should have_content "Users"
			end

			it "displays a list of all users" do
				page.should have_content @user.name
				page.should have_content @admin.name
			end
		end
	end

	describe "#show" do
				
		context "for unauthorized users" do
			it_behaves_like "authentication" do 
				let(:user) { FactoryGirl.create(:user) }
				let(:path) { user_path(@user) }
			end
		end

		context "when user is authorized" do
			it "displays the user's page" do
				login_as @user, :scope => :user
				visit user_path(@user)
				page.should have_content @user.name
			end
		end

		context "when user is admin" do
			it "allows admin access to other users' pages" do
				login_as @admin, :scope => :user
				visit user_path(@user)
				page.should have_content @user.name
			end
		end
	end

	describe "#edit" do

		context "for unauthorized users" do
			it_behaves_like "authentication" do
				let(:path) { edit_user_path(@user) }
				let(:user) { @user }
			end
		end

		context "for admin user" do
			before(:each) do 
				login_as @admin, :scope => :user
				visit edit_user_path(@user)
			end

			it "allows admin to edit user data" do
				fill_in "Name", :with => "yippee"
				find(:css, 'input[type="submit"]').click
				User.find(@user.id).name.should eq "yippee"
			end

			it "allows admin to give user admin role", :js => true do
				find('#admin').click
				find(:css, 'input[type="submit"]').click
				User.find(@user.id).should have_role :admin				
			end

			it "allows admin to remove user admin role", :js => true do
				@user.add_role :admin
				visit edit_user_path @user
				find('#admin').click
				find(:css, 'input[type="submit"]').click
				User.find(@user.id).should_not have_role :admin						
			end
		end
	
	end


	context "when logged in as admin" do
		before(:each) do
			login_as @admin, :scope => :user
			visit root_path
		end

		it "root path displays admin options" do
			page.should have_content("Manage")
		end

	end

	context "when no user is logged in" do
		it "visiting a page requires user to sign in" do
			visit root_path
			page.should have_content("You need to sign in or sign up")
		end
	end

	context "when non-admin user is logged in" do
		before(:each) do
			login_as @user, :scope => :user
		end

		it "user path doesn't display admin options" do
			visit user_path(@user)
			page.should_not have_content("Manage")
		end

		it "doesn't allow user to view other users pages" do
			visit user_path(@admin)
			page.should have_content("You are not authorized to access this page")
		end

		it "doesn't allow user to view users index" do
			visit users_path
			page.should have_content("You are not authorized to access this page")
		end
	end

end