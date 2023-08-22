require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('User').with_foreign_key('creator_id') }
    it { should belong_to(:house).class_name('House').with_foreign_key('house_id') }
  end
end
