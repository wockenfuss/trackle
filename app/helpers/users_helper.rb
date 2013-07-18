module UsersHelper

	def status_bar(user)
		if user.current_assignment != "none"
			if user.current_assignment.status == "in progress"
				return "Started at #{user.current_assignment.started_at.localtime.strftime("%l:%M %p, %-m/%d/%Y")}"
			else
				return user.current_assignment.status
			end
		end
	end

	def hold_resume(item)
		if @user.current_assignment.status == "in progress"
			return ""
		else 
			return link_to 'resume', assignment_path(item, :assignment => 
			{:hold => false}), :method => 'put', :remote => true
		end
	end

end