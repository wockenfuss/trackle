class CitiesController < ApplicationController
	load_and_authorize_resource
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
			render edit_city_path(@city), :error => "Something went wrong"
		end
	end

	def create
		@city = City.create(params[:city])
		if @city.save
			redirect_to cities_path, :notice => "City created"
		else
			render 'index', :error => "Something went wrong"
		end
	end

	def destroy
		@city = City.find(params[:id])
		if @city.destroy
			redirect_to cities_path, :notice => "City deleted"
		end
	end

end