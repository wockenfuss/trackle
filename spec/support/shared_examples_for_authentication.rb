shared_examples_for "authentication" do
  it "displays a warning to a not logged in user" do
  	visit path 
  	page.should have_content "You need to sign in or sign up"
  end

  it "displays a warning to unauthorized user" do
  	login_as user, :scope => :user
  	visit path
		page.should have_content "You are not authorized"
  end
end
