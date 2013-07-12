class AssignmentsController < ApplicationController
	respond_to :js, :html, :json
	def create
		@assignment = Assignment.create(params[:assignment])
		if @assignment.save
			respond_with(@assignment)
	
		else
			respond_with( {:error => "error"}, :location => nil)
		end
	end
end