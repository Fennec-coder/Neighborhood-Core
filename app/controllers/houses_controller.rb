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
    typical_response House::Register, :created
  end

  def destroy
    typical_response House::Delete, :no_content
  end

  def update
    typical_response House::Update, :ok
  end

  private

  def typical_response(service_class, positive_status, negative_status = :unprocessable_entity)
    result = service_class.new(house_params.to_h).call

    if result.success?
      render json: result.value!
    else
      render json: { errors: result.failure }, status: :not_found
    end
  end

  def house_params
    params.require(:house).permit(:creator_id, :address, :latitude, :longitude)
      .merge(params.permit(:id))
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
end
