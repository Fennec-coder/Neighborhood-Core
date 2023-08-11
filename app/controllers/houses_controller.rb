# frozen_string_literal: true

class HousesController < ApplicationController
  before_action :authenticate_user!

  def index
    unless home_search_area
      render json: { errors: ['Please provide search parameters.'] },
             status: :unprocessable_entity and return
    end

    result = House::GetCoordinatesByRange.new(home_search_area).call

    if result.success?
      render json: result.value!
    else
      render json: { errors: result.failure }, status: :unprocessable_entity
    end
  end

  def show
    house = House.find_by(id: params[:id])

    if house
      render json: house.to_json
    else
      render status: :not_found
    end
  end

  def create
    result = House::Register.new(house_params.to_h).call

    if result.success?
      render json: result.value!
    else
      render json: { errors: result.failure }, status: :unprocessable_entity
    end
  end

  #### below - update ####

  def destroy
    @house = House.find(params[:id])
    @house.destroy
    redirect_to houses_path
  end

  def edit
    @house = House.find(params[:id])
  end

  def update
    @house = House.find(params[:id])
    if @house.update(house_params)
      redirect_to @house
    else
      render :edit
    end
  end

  private

  def house_params
    params.require(:house).permit(:creator_id, :address, :latitude, :longitude)
  end

  def home_search_area
    @home_search_area ||= {
      top_right: calculate_coordinates(params[:topRightCoords]),
      bottom_left: calculate_coordinates(params[:bottomLeftCoords])
    }
  end

  def calculate_coordinates(coords)
    return unless coords

    coords.split(',').map { |coord| coord.to_f }
  end

  def geografic(longitude, latitude)
    RGeo::Geographic.spherical_factory.point(longitude, latitude)
  end
end
