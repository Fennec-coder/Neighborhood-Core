# frozen_string_literal: true

class House::GetCoordinatesByRange
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :home_search_area

  def call
    validation_result = HouseCoordinatesSchema.call(home_search_area)

    if validation_result.failure?
      Failure(validation_result.errors)
    else
      Success(
        House.where(
          'ST_Intersects(location, ST_MakeEnvelope(?, ?, ?, ?))',
          *validation_result[:top_left],
          *validation_result[:bottom_right]
        )
      )
    end
  end
end
