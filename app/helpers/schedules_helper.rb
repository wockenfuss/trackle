module SchedulesHelper

	def task_progress_bar(task, city)
		assignments = task.assignments.where(:city_id => city.id)
		return "0/#{assignments.count}"
	end
end