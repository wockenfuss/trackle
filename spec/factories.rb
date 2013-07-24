FactoryGirl.define do
	
	factory :announcement do
		content { Faker::Lorem.sentence(word_count = 8, supplemental = false ) }
		subject { Faker::Lorem.sentence(word_count = 2, supplemental = false ) }
		user_id 1
		begin_date { Time.now }
		end_date { 1.day.from_now.to_date }
	end

	factory :user do
		name { Faker::Name.name }
    email { Faker::Internet.email }
    password "password"
	end

	factory :assignment do 
		duration 8
		deadline { 1.day.from_now }
		hold false
		amount_completed 0
		user_id 1
		task_id 1
		city_id 1
		queue_index 1
	end

	factory :city do
		name { Faker::Address.city }
		deadline { 1.day.from_now }
		hold false
		color "#fff"
	end

	factory :comment do
		content { Faker::Lorem.sentence(word_count = 5, supplemental = false ) }
		assignment_id 1
		user_id 1
	end

	factory :task do
		name { Faker::Lorem.sentence(word_count = 2, supplemental = false ) }
		color "#fff"
	end
end