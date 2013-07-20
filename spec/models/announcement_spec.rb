require 'spec_helper'

describe Announcement do
  subject { FactoryGirl.create(:announcement) }

  [:content, :user_id, :subject, :end_date].each do |attr|
  	it { should validate_presence_of attr }
  end

	it { should belong_to :user }

	[:begin_date, :content, :end_date, :subject, :user_id].each do |attr|
		it { should respond_to attr }
	end	

	describe ".current" do
		before(:each) do
			@announcement = FactoryGirl.create(:announcement)
			@expired = FactoryGirl.create(:announcement, :end_date => Time.now)
		end

		it "returns a list of current announcements" do
			Announcement.current.should include @announcement
			Announcement.current.should_not include @expired
		end
	end
end