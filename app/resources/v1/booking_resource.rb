class V1::BookingResource < JSONAPI::Resource
  attributes :name, :booking_type, :contact_person, :email, :tickets, :phone_nr, :token

  has_one :event
end
