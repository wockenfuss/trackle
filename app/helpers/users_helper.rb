module UsersHelper

	def status_bar(user)
		if user.current_assignment != "none"
			if user.current_assignment.status == "in progress"
				Time.zone = 'America/Los_Angeles'
				return "Started at #{user.current_assignment.started_at.in_time_zone.strftime("%l:%M %p, %-m/%d/%Y")}"
			else
				return user.current_assignment.status
			end
		end
	end

end