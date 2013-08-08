module AssignmentsHelper
	def assignment_submit_label(assignment)
		if assignment.new_record?
			return "Assign"
		else
			return "Update"
		end
	end

	def assignment_queue_index(assignment)
		assignment.queue_index || assignment.user.assignments.count + 1
	end
end