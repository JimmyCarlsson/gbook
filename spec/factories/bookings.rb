FactoryGirl.define do
  factory :booking do
    tickets 1
    booking_type 'private'
    email 'test@test.test'
    phone_nr 123456
    name "name namesson"
    association :event, factory: :event
    
  end
end
