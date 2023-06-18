# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :creator, class_name: 'User',  foreign_key: 'creator_id'
  belongs_to :house,   class_name: 'House', foreign_key: 'house_id'
end
