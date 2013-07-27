require 'spec_helper'

describe SchedulesHelper do

	describe "#task_progress_bar" do
		before(:each) do 
			@user = FactoryGirl.create(:user)
			@project = FactoryGirl.create(:project)
			@task = FactoryGirl.create(:task)
			@complete = FactoryGirl.create(:assignment, :task_id => @task.id, 
																									:project_id => @project.id,
																									:started_at => Time.now,
																									:resumed_at => Time.now,
																									:completed_at => Time.now,
																									:user_id => @user.id)
			@incomplete = FactoryGirl.create(:assignment, :task_id => @task.id,
																										:project_id => @project.id)
		end

		it "returns a list of completed assignments out of total" do
			task_progress_bar(@task, @project).should eq "1/2"
		end
	end

	describe "#parse_time" do
		before(:each) do
			@time = Time.now
		end

		it "returns a date formatted months/days/year" do
			parse_time(@time).should eq @time.strftime("%-m/%d/%Y")
		end

	end

end