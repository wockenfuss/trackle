class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
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
      string = DateTime.strptime(string, '%m/%d/%Y') + utc_offset_in_hours(Time.now).hours
    end
    string
  end

  def js_redirect_to(path)
    render js: %(window.location.href='#{path}') and return
  end
  
  def js_alert(current_object)
    render "shared/errors", :locals => { :current_object => current_object, :target => targetId(current_object) }
  end

  def targetId(object)
    case object
    when @announcement
      return '#announcementErrors'
    when @task_group
      return '#taskGroupErrors'
    else
      return '#alerts'
    end
  end

  private

  def utc_offset_in_hours(time)
    time.utc_offset.abs/(60 * 60)
  end

end
