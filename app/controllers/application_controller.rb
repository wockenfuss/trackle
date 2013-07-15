class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
  	p resource
  	if can? :manage, :all
  		return root_path
  	else
  		return user_path(resource)
  	end
	end

	rescue_from CanCan::AccessDenied do |exception|
    redirect_to user_path(current_user), :alert => exception.message
  end

  def parse_dates(params)
    deadline = params[:deadline] || ""
    params[:deadline] = parsed_date(deadline) unless deadline == ""
  end

  def parsed_date(string)
    begin
      string = DateTime.strptime(string, '%Y-%m-%d %H:%M:%S')
    rescue => error
      string = DateTime.strptime(string, '%m/%d/%Y')
    end
    string
  end

end
