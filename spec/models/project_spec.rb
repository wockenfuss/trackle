require 'spec_helper'

describe Project do
  subject { FactoryGirl.create(:project) }

  [:name, :color].each do |attr|
  	it { should validate_presence_of attr }
  end

	it { should have_many :assignments }

	[:deadline, :name, :color].each do |attr|
		it { should respond_to attr }
	end	

end
