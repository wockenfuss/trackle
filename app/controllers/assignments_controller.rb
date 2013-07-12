class AssignmentsController < ApplicationController
	respond_to :js, :html, :json
	def create
		@assignment = Assignment.new(params[:assignment])
		if @assignment.save
			@color = @assignment.user.current_color
			respond_with(@assignment, @color)
		else
			respond_with( {:error => "error"}, :location => nil)
		end
	end

	def destroy 
		@assignment = Assignment.find(params[:id])
		@user = @assignment.user
		if @assignment.destroy
			respond_with @user
		end
	end
end