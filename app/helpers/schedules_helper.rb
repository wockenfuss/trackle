module SchedulesHelper

	def task_progress_bar(task, city)
		total_assignments = task.assignments.where(:city_id => city.id)
		completed_assignments = total_assignments.where('completed_at is NOT NULL')
		return "#{completed_assignments.count}/#{total_assignments.count}"
	end
	def parse_time(datetime)
		datetime.strftime("%-m/%d/%Y") if datetime
	end
end