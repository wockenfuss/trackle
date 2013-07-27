require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }

 	it { should validate_presence_of :name }

	[:email, :password, :password_confirmation, :remember_me, 
		:absent, :available, :name, :admin].each do |attr|
		it { should respond_to attr }
	end	

	before(:each) do
		@user = FactoryGirl.create(:user)
	end

	describe ".non_admin" do
		before(:each) do 
			@admin = FactoryGirl.create(:user)
			@admin.add_role :admin
		end

		it "returns a list of non admin users" do
			User.non_admin.should_not include @admin
			User.non_admin.should include @user
		end
	end

	describe "#update_admin" do
		before(:each) do 
			@admin = FactoryGirl.create(:user)
			@admin.add_role :admin
		end

		it "gives a user admin privileges when passed admin" do
			@user.update_admin({:admin => true})
			@user.should have_role :admin
		end

		it "removes admin privileges when not passed admin" do
			@admin.update_admin({:admin => false })
			@admin.should_not have_role :admin
		end
	end

	describe "#assigned?" do
		before(:each) do 
			@other_user = FactoryGirl.create(:user)
			@assignment = FactoryGirl.create(:assignment, :user_id => @user.id)
		end

		it "returns true if a user has an assignment" do
			@user.assigned?.should be_true
		end

		it "returns false if a user has no assignment" do
			@other_user.assigned?.should be_false
		end

		it "returns true if a user has an assignment on hold" do
			@assignment.update_attributes(:resumed_at => Time.now, :hold => true)
			@user.assigned?.should be_true
		end
	end

	describe "#completed_assignments" do
		before(:each) do 
			@incomplete = FactoryGirl.create(:assignment, :user_id => @user.id)
			@complete = FactoryGirl.create(:assignment, :user_id => @user.id, 
																			:started_at => Time.now,
																			:resumed_at => Time.now, 
																			:completed_at => Time.now)
		end

		it "returns a list of completed assignments" do
			@user.completed_assignments.should include @complete 
		end

		it "does not return incomplete assignments" do
			@user.completed_assignments.should_not include @incomplete 
		end
	end

	describe "#on_hold" do
		before(:each) do 
			@on_hold = FactoryGirl.create(:assignment, 
																		:user_id => @user.id, 
																		:started_at => Time.now,
																		:resumed_at => Time.now, 
																		:hold => true)
			@assignment = FactoryGirl.create(:assignment, 
																		:user_id => @user.id,
																		:started_at => Time.now,
																		:resumed_at => Time.now)
		end

		it "returns a list of assignments on hold" do
			@user.on_hold.should include @on_hold
		end

		it "does not return assignments not on hold" do
			@user.on_hold.should_not include @assignment
		end
	end

end
