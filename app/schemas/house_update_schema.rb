HouseUpdateSchema = Dry::Schema.Params do
  required(:id).maybe(:integer)
  optional(:address).filled(:string)
  optional(:latitude).maybe(:float)
  optional(:longitude).maybe(:float)
end
