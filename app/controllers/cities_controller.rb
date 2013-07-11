class CitiesController < ApplicationController

	def index
		@cities = City.all
		@city = City.new
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