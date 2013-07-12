class AssignmentsController < ApplicationController
	respond_to :js, :html, :json
	def create
		@assignment = Assignment.new(params[:assignment])
		@color = @assignment.user.current_color
		if @assignment.save
			respond_with(@assignment, @color)
		else
			respond_with( {:error => "error"}, :location => nil)
		end
	end
end