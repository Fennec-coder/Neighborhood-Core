# spec/models/house_spec.rb

require 'rails_helper'

RSpec.describe House, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:address) }
    it { should validate_uniqueness_of(:address) }
    it { should validate_presence_of(:location) }
  end

  describe 'associations' do
    it { should belong_to(:creator).class_name('User').with_foreign_key('creator_id') }
    it { should have_many(:user_house_subscriptions) }
    it { should have_many(:subscribers).through(:user_house_subscriptions) }
  end
end
