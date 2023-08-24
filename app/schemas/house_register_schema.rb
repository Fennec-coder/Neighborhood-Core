HouseRegisterSchema = Dry::Schema.Params do
  required(:address).filled(:string)
  required(:latitude).maybe(:float)
  required(:longitude).maybe(:float)
end
