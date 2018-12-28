FactoryGirl.define do
  factory :event, class: Event do
    name "TestEventName"
    description "TestEventDescription"
    date DateTime.now
    price 100
    tax25 100
    tax12 0
    tax6 0
    seats 100
    deleted_at nil

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end
end
