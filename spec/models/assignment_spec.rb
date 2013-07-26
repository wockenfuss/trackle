require 'spec_helper'

describe Assignment do
	subject { FactoryGirl.create(:assignment) }

 	it { should validate_presence_of :queue_index }

	it { should belong_to :user }
	it { should belong_to :task }
	it { should belong_to :city }

	[:amount_completed, :completed_at, :deadline, :duration, 
		:hold, :started_at, :user_id, :task_id, 
		:city_id, :queue_index].each do |attr|
		it { should respond_to attr }
	end	

	describe "#status" do
		before(:each) do 
			@user = FactoryGirl.create(:user)
			@completed = FactoryGirl.create(:assignment, :completed_at => Time.now, :user_id => @user.id)
			@in_progress = FactoryGirl.create(:assignment, :started_at => Time.now)
			@hold = FactoryGirl.create(:assignment, :started_at => Time.now, :hold => true)
			@not_started = FactoryGirl.create(:assignment)
		end

		it "returns completed if the assignment is complete" do
			@completed.status.should eq "completed"
		end

		it "returns in progress if the assignment is in progress" do
			@in_progress.status.should eq "in progress"
		end

		it "returns on hold if the assignment is on hold" do
			@hold.status.should eq "on hold"
		end

		it "returns not yet begun if the assignment isn't started" do
			@not_started.status.should eq "not yet begun"
		end

	end	

end
