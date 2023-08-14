# frozen_string_literal: true

# This module provides tools for working with coordinate zones and calculating coordinates.
#
module HousesController::CoordinateZoneTools
  # Parses the top left and bottom right coordinates of a zone.
  #
  # @return [Hash] A hash containing the parsed top left and bottom right coordinates.
  def home_search_area
    @home_search_area ||= {
      top_left: calculate_coordinates(params[:topLeftCoords]),
      bottom_right: calculate_coordinates(params[:bottomRightCoords])
    }
  end

  # Calculates coordinates from a comma-separated string.
  #
  # @param coords [String] The comma-separated coordinates.
  # @return [Array<Float>] An array of coordinates as floats.
  def calculate_coordinates(coords)
    return unless coords

    coords.split(',').map { |coord| coord.to_f }
  end
end
