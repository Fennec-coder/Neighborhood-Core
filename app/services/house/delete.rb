# frozen_string_literal: true

HouseSchema = Dry::Schema.Params do
  required(:id).maybe(:integer)
  required(:creator_id).maybe(:integer)
end

class House::Delete
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :house_params

  def call
    validated_params = HouseSchema.call(house_params)

    return Failure(validated_params.errors) if validated_params.failure?

    params = validated_params.to_h

    house = House.find_by(params)

    return Failure("The user's registered home was not found") if house.blank?

    if house.delete
      Success('Deleted successfully')
    else
      Failure(house.errors)
    end
  end
end
