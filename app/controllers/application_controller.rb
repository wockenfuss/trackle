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
end
