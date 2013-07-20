require 'spec_helper'

describe ApplicationHelper do

	describe "#trackle_root" do 
		before(:each) do 
			@user = FactoryGirl.create(:user)
			@admin = FactoryGirl.create(:user)
			@admin.add_role :admin
		end

		it "returns the root path for an admin user" do
			trackle_root(@admin).should eq root_path
		end

		it "returns the user_path for non-admin user" do
			trackle_root(@user).should eq user_path(@user)
		end

		it "returns the root path if there's no user signed in" do
			trackle_root(nil).should eq root_path
		end

	end

end