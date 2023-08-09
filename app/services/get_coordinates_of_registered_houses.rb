# frozen_string_literal: true

HouseCoordinatesSchema = Dry::Schema.Params do
  required(:bottom_left).array(:float).value(size?: 2)
  required(:top_right).array(:float).value(size?: 2)
end

class GetCoordinatesOfRegisteredHouses
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
          *validation_result[:bottom_left],
          *validation_result[:top_right]
        )
      )
    end
  end
end
