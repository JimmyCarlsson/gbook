class V1::EventResource < JSONAPI::Resource
  attributes :name, :description, :date, :price, :seats, :availability_string

  has_many :bookings
end
