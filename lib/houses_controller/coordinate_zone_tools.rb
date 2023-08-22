# frozen_string_literal: true

# This module provides tools for working with coordinate zones and calculating coordinates.
#
module HousesController::CoordinateZoneTools
  # Parses the top left and bottom right coordinates of a zone.
  #
  # @return [Hash] A hash containing the parsed top left and bottom right coordinates.
  def home_search_area
    @home_search_area ||= {
      top_left: params[:topLeftCoords],
      bottom_right: params[:bottomRightCoords]
    }
  end
end
