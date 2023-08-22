require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end

  describe 'associations' do
    it { should have_many(:created_houses).class_name('House').with_foreign_key('creator_id') }
    it { should have_many(:user_house_subscriptions) }
    it { should have_many(:subscribed_houses).through(:user_house_subscriptions).source(:house) }
  end

  describe 'Devise modules' do
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_confirmation_of(:password) }
    it { should validate_length_of(:password).is_at_least(Devise.password_length.min) }
    it { should validate_length_of(:password).is_at_most(Devise.password_length.max) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end
end
