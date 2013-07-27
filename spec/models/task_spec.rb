require 'spec_helper'

describe Task do
	subject { FactoryGirl.create(:task) }

 	it { should validate_presence_of :name}

	it { should have_many :assignments }

	[:name, :color].each do |attr|
		it { should respond_to attr }
	end	

  describe "#assignments_for_project" do
		before(:each) do
			@task = FactoryGirl.create(:task)
			@project = FactoryGirl.create(:project)
			@project2 = FactoryGirl.create(:project)
			@assignment = FactoryGirl.create(:assignment, :project_id => @project.id, :task_id => @task.id)
			@assignment2 = FactoryGirl.create(:assignment, :project_id => @project2.id, :task_id => @task.id)
		end

		it "returns a list of task assignments for a specified project" do
			@task.assignments_for_project(@project).should include @assignment
			@task.assignments_for_project(@project).should_not include @assignment2
		end
	end
end
