class V1::BookingResource < JSONAPI::Resource
  attributes :name, :booking_type, :contact_person, :email, :tickets, :phone_nr, :token, :created_at, :updated_at, :message, :discount, :discount_message, :memo, :paid

  has_one :event

  def self.updatable_fields(context)
    return super - [:token, :created_at, :updated_at]
  end

  def self.creatable_fields(context)
    return super - [:token, :created_at, :updated_at, :paid, :discount, :memo, :discount_message]
  end

  def fetchable_fields
    pp context
    if context[:admin_signed_in] == true
      super
    else
      super - [:memo]
    end
  end
end
