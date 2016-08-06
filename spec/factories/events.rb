FactoryGirl.define do
  factory :event, class: Event do
    name "TestEventName"
    description "TestEventDescription"
    date DateTime.now
    price 100
    seats 100
    deleted_at nil
  end
end
