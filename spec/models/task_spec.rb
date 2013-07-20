require 'spec_helper'

describe Task do
  describe "#assignments_for_city" do
		before(:each) do
			@city = FactoryGirl.create(:city)
			@city2 = FactoryGirl.create(:city)
			@assignment = FactoryGirl.create(:assignment, :city_id => @city.id)
			@assignment2 = FactoryGirl.create(:assignment, :city_id => @city2.id)
		end

	end
end
