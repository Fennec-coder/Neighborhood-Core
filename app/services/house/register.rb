# frozen_string_literal: true

HouseSchema = Dry::Schema.Params do
  required(:creator_id).maybe(:integer)
  required(:address).filled(:string)
  required(:latitude).maybe(:float)
  required(:longitude).maybe(:float)
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

    house = House.new(
      address: params[:address],
      creator_id: params[:creator_id],
      location:
        RGeo::Geographic.spherical_factory(srid: 4326)
          .point(params[:longitude], params[:latitude])
    )

    if house.save
      Success(house)
    else
      Failure(house.errors)
    end
  end
end
