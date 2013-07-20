require 'spec_helper'

describe Task do
	subject { FactoryGirl.create(:task) }

 	it { should validate_presence_of :name}

	it { should have_many :assignments }

	[:name, :color].each do |attr|
		it { should respond_to attr }
	end	

  describe "#assignments_for_city" do
		before(:each) do
			@task = FactoryGirl.create(:task)
			@city = FactoryGirl.create(:city)
			@city2 = FactoryGirl.create(:city)
			@assignment = FactoryGirl.create(:assignment, :city_id => @city.id, :task_id => @task.id)
			@assignment2 = FactoryGirl.create(:assignment, :city_id => @city2.id, :task_id => @task.id)
		end

		it "returns a list of task assignments for a specified city" do
			@task.assignments_for_city(@city).should include @assignment
			@task.assignments_for_city(@city).should_not include @assignment2
		end
	end
end
