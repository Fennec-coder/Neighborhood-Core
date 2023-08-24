# frozen_string_literal: true

class HousesController < ApplicationController
  include CoordinateZoneTools

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
    render_response House::Register, :created
  end

  def destroy
    render_response House::Delete, :no_content
  end

  def update
    render_response House::Update, :ok
  end

  private

  def house_params
    params.require(:house).permit(:address, :latitude, :longitude).merge(params.permit(:id))
  end

  def render_response(service_class, positive_status, negative_status = :unprocessable_entity)
    result = service_class.new(house_params.to_h, current_user.id).call

    if result.success?
      render json: result.value!, status: positive_status
    else
      render json: { errors: result.failure }, status: negative_status
    end
  end
end
