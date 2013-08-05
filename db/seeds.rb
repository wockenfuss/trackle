15.times do 
	first_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	email = Faker::Internet.email
	User.create(:name => "#{first_name} #{last_name}", :email => email, :password => "password")
end

admin = User.create(:name => "Foo", :email => "foo@foo.com", :password => "password")
admin.add_role :admin

5.times do 
	color = "##{'%06x' % (rand * 0xffffff)}"
	Project.create(:name => Faker::Address.city, :color => color)
end

10.times do |i|
	color = "##{'%06x' % (rand * 0xffffff)}"
	Task.create(:name => "Task #{i}", :color => color)
end
