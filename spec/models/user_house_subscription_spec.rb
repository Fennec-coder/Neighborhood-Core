require 'rails_helper'

RSpec.describe UserHouseSubscription, type: :model do
  describe 'associations' do
    it { should belong_to(:subscriber).class_name('User').with_foreign_key('user_id') }
    it { should belong_to(:house) }
  end
end
