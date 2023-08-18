HouseRegisterSchema = Dry::Schema.Params do
  required(:creator_id).maybe(:integer)
  required(:address).filled(:string)
  required(:latitude).maybe(:float)
  required(:longitude).maybe(:float)
end
