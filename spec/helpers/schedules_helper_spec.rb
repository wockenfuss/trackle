require 'spec_helper'

describe SchedulesHelper do

	describe "#task_progress_bar" do
		before(:each) do 
			@city = FactoryGirl.create(:city)
			@task = FactoryGirl.create(:task)
			@complete = FactoryGirl.create(:assignment, :task_id => @task.id, 
																									:city_id => @city.id,
																									:started_at => Time.now,
																									:completed_at => Time.now)
			@incomplete = FactoryGirl.create(:assignment, :task_id => @task.id,
																										:city_id => @city.id)
		end

		it "returns a list of completed assignments out of total" do
			task_progress_bar(@task, @city).should eq "1/2"
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