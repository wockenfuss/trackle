class ArchivesController < ApplicationController
	load_and_authorize_resource
	before_filter :authenticate_user!

	def show
		@projects = Project.where('completed_at is NOT NULL')
	end
end