require 'spec_helper'

describe UsersHelper do

	before(:each) do 
		@user = FactoryGirl.create(:user) 
		@assignment = FactoryGirl.create(:assignment, :user_id => @user.id)
	end

	describe "#status_bar" do
		before(:each) do
		end

		it "returns the start time if current assignment is in progress" do
			@assignment.update_attributes(:started_at => Time.now)
			status_bar(@user).should eq "Started at #{@assignment.started_at.localtime.strftime("%l:%M %p, %-m/%d/%Y")}"
		end

		it "returns the current assignment status for not started assignments" do
			status_bar(@user).should eq "not yet begun"
		end

		it "returns current assignment status for on hold assignments" do
			@assignment.update_attributes(:started_at => Time.now,
																		:hold => true)
			status_bar(@user).should eq "on hold"
		end
	end

	describe "#hold_resume" do
		before(:each) { @assignment.update_attributes(:started_at => Time.now,
																									:hold => true)}

		it "returns a link to resume the assignment if no other assignment is in progress" do
			hold_resume(@assignment).should eq link_to 'resume', assignment_path(item, :assignment => 
			{:hold => false, :resumed_at => true}), :method => 'put', :remote => true
		end

		it "returns nothing if another assignment is in progress" do
			@other_assignment = FactoryGirl.create(:assignment, :user_id => @user.id,
																													:started_at => Time.now)
			hold_resume(@assignment).should eq ""
		end

	end
end