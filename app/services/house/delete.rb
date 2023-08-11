# frozen_string_literal: true

HouseSchema = Dry::Schema.Params do
  required(:id).maybe(:integer)
  required(:house_id).maybe(:integer)
end

# RegisterHouse — это сервисный класс, отвечающий за регистрацию нового дома.
#
class House::Register
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :house_params

  def call
    validated_params = HouseSchema.call(house_params)

    return Failure(validated_params.errors) if validated_params.failure?

    params = validated_params.to_h

    house = House.find_by(params)

    return Failure("The user's registered home was not found") if house.present?

    if house.delete
      Success()
    else
      Failure(house.errors)
    end
  end
end
