# frozen_string_literal: true

class UserHouseSubscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User', foreign_key: 'user_id'
  belongs_to :house
end
