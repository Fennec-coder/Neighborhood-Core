class UserHouseSubscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User'
  belongs_to :house
end
