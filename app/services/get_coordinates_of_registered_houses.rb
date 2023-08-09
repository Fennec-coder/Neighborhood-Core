# frozen_string_literal: true

require 'dry-initializer'

#
#
class GetCoordinatesOfRegisteredHouses
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :bottom_left
  param :top_right


end