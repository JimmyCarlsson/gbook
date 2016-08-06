FactoryGirl.define do
  factory :admin, class: Admin do
    sequence(:email) { |n| "person#{n}@example.com" }
    password "secret"
  end
end
