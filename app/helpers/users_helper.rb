module UsersHelper

	def status_bar(user)
		if user.current_assignment != "none"
			if user.current_assignment.status == "in progress"
				# return "Started at #{user.current_assignment.started_at}"
				return "Started at #{user.current_assignment.started_at.localtime.strftime("%-m %d %Y, %l:%M %p")}"
			else
				return user.current_assignment.status
			end
		end
	end

end