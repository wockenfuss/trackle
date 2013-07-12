# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

15.times do 
	first_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	email = Faker::Internet.email
	User.create(:name => "#{first_name} #{last_name}", :email => email)
end

5.times do 
	color = "##{'%06x' % (rand * 0xffffff)}"
	City.create(:name => Faker::Address.city, :color => color)
end

10.times do |i|
	color = "##{'%06x' % (rand * 0xffffff)}"
	Task.create(:name => "Task #{i}", :color => color)
end
