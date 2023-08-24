# frozen_string_literal: true

class House::Update
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :house_params
  param :user_id

  def call
    validated_params = HouseUpdateSchema.call(house_params)

    return Failure(validated_params.errors) if validated_params.failure?

    params = validated_params.to_h

    house = House.find_by(params.slice(:id, :user_id))

    return Failure('House not found') if house.nil?

    if house.update(params)
      Success(house)
    else
      Failure(house.errors)
    end
  end
end
