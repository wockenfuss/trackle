require 'spec_helper'

describe Comment do
  subject { FactoryGirl.create(:comment) }

 	it { should validate_presence_of :content }
 	it { should validate_presence_of :user_id }

	it { should belong_to :user }
	it { should belong_to :assignment }

	[:assignment_id, :content, :user_id].each do |attr|
		it { should respond_to attr }
	end	
end
