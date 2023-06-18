# frozen_string_literal: true

class House < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :address, presence: true, uniqueness: true
  validates :location, presence: true

  has_many :user_house_subscriptions
  has_many :houses, through: :user_house_subscriptions
end
