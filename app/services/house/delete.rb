# frozen_string_literal: true

class House::Delete
  extend  Dry::Initializer
  include Dry::Monads[:result]

  HouseSchema = Dry::Schema.Params do
    required(:id).maybe(:integer)
  end

  param :house_params
  param :user_id

  def call
    validated_params = HouseSchema.call(house_params)

    return Failure(validated_params.errors) if validated_params.failure?

    params = validated_params.to_h

    house = House.find_by(params.merge(creator_id: user_id))

    return Failure("The user's registered home was not found") if house.blank?

    if house.delete
      Success('Deleted successfully')
    else
      Failure(house.errors)
    end
  end
end
