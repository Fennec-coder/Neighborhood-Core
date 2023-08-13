# frozen_string_literal: true

HouseSchema = Dry::Schema.Params do
  required(:id).maybe(:integer)
  required(:creator_id).maybe(:integer)
  optional(:address).filled(:string)
  optional(:latitude).maybe(:float)
  optional(:longitude).maybe(:float)
end

class House::Update
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :house_params

  def call
    validated_params = HouseSchema.call(house_params)

    return Failure(validated_params.errors) if validated_params.failure?

    params = validated_params.to_h

    house = House.find_by(params.slice(:id, :creator_id))

    return Failure('House not found') if house.nil?

    if house.update(params)
      Success(house)
    else
      Failure(house.errors)
    end
  end
end
