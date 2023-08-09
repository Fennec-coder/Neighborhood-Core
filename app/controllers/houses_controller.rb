# frozen_string_literal: true

class HousesController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def show
    @house = House.find(params[:id])
  end

  def new
    @house = House.new
  end

  def create
    @house = House.new(house_params)
    @house.location = "POINT(#{location_params.values.join(' ')})"
    @house.creator = current_user

    if @house.save
      redirect_to house_path(@house), notice: "Congratulations! House successfully registered!"
    else
      redirect_to :new_house, alert: @house.errors.full_messages.join(', ')
    end
  end

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

  def coordinates
    houses = House.where(
      'ST_Intersects(location, ST_MakeEnvelope(?, ?, ?, ?))',
      *home_search_area[:bottom_left],
      *home_search_area[:top_right]
    ) if home_search_area

    render json: houses.to_json
  end

  private

  def house_params
    params.require(:house).permit(:name, :address)
  end

  def location_params
    params.require(:house).permit(:latitude, :longitude)
  end

  def home_search_area
    return unless search_area_params_present?

    additional_loading = ENV['ADDITIONAL_LOADING_OF_MAP'].to_f

    @home_search_area ||= {
      top_right: calculate_coordinates(params[:topRightCoords], additional_loading),
      bottom_left: calculate_coordinates(params[:bottomLeftCoords], -additional_loading)
    }
  end

  def search_area_params_present?
    params[:topRightCoords].present? && params[:bottomLeftCoords].present?
  end

  def calculate_coordinates(coords, adjustment)
    coords.split(',').map { |coord| coord.to_f + adjustment }
  end

  def geografic(longitude, latitude)
    RGeo::Geographic.spherical_factory.point(longitude, latitude)
  end
end
