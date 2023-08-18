HouseCoordinatesSchema = Dry::Schema.Params do
  required(:top_left).array(:float).value(size?: 2)
  required(:bottom_right).array(:float).value(size?: 2)
end
