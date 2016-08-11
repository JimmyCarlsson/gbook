class V1::BookingResource < JSONAPI::Resource
  attributes :name, :booking_type, :contact_person, :email, :tickets, :phone_nr, :token, :created_at, :updated_at

  has_one :event
end
