FactoryBot.define do
  factory :house do
    address  { 'Some place in the Atlantic Ocean' }
    location { 'POINT(0 0)' }
    creator  { create(:user) }
  end
end
