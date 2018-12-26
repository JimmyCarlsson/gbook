FactoryGirl.define do
  factory :booking do
    tickets 1
    booking_type 'private'
    email 'test@test.test'
    phone_nr 123456
    name "name namesson"
    due_date DateTime.now + 10.days 
    delivery_date DateTime.now
    address_street 'street'
    address_zip '11122'
    address_city 'City'
    association :event, factory: :event
    
  end
end
