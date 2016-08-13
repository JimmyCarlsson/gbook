class V1::BookingResource < JSONAPI::Resource
  attributes :name, :booking_type, :contact_person, :email, :tickets, :phone_nr, :token, :created_at, :updated_at

  has_one :event

  def self.updatable_fields(context)
    super - [:token, :created_at, :updated_at]
  end

  def self.creatable_fields(context)
    super - [:token, :created_at, :updated_at]
  end
end
