class V1::BookingResource < JSONAPI::Resource
  attributes :name, :booking_type, :contact_person, :email, :tickets, :phone_nr, :token, :created_at, :updated_at, :message, :discount, :discount_message, :memo, :paid, :total_price

  has_one :event

  def self.updatable_fields(context)
    return super - [:token, :created_at, :updated_at, :total_price]
  end

  def self.creatable_fields(context)
    return super - [:token, :created_at, :updated_at, :paid, :discount, :memo, :discount_message, :total_price]
  end

  def fetchable_fields
    if context[:admin_signed_in] == true
      super
    else
      #super - [:memo]
      super
    end
  end

  after_save do
    pp @model
    BookingMailer.booking_email(@model).deliver_now
  end
end
