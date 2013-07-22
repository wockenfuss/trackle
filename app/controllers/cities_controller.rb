class CitiesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	before_filter :parse_params, :only => [:create, :update]

	def index
		@cities = City.all
		@city = City.new
	end

	def edit
		@city = City.find(params[:id])
	end

	def update
		@city = City.find(params[:id])
		if @city.update_attributes(params[:city])
			redirect_to cities_path, :notice => "City updated"
		else 
			redirect_to edit_city_path(@city), :alert => "Something went wrong"
		end
	end

	def create
		@city = City.create(params[:city])
		if @city.save
			redirect_to cities_path, :notice => "City created"
		else
			redirect_to cities_path, :alert => "Something went wrong"
		end
	end

	def destroy
		@city = City.find(params[:id])
		if @city.destroy
			redirect_to cities_path, :notice => "City deleted"
		end
	end

	private
	def parse_params
		parse_dates(params[:city]) if params[:city]
	end
end