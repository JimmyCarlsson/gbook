class V1::BookingResource < JSONAPI::Resource
  attributes :name, :booking_type, :contact_person, :email, :tickets, :phone_nr, :token, :created_at, :updated_at, :message, :discount, :discount_message, :memo, :paid, :total_price

  has_one :event

  def self.updatable_fields(context)
    non_updateables =  [:token, :created_at, :updated_at, :total_price]

    return super - non_updateables
  end

  def self.creatable_fields(context)
    # These should never be updated through json api
    non_creatables =  [:token, :created_at, :updated_at, :total_price]
    return super - non_creatables 
  end

  def self.fetchable_fields(context)
    if context[:current_admin].present?
      super
    else
      super - [:memo]
    end
  end

  before_save do
    # If not admin, make sure certain field have not been set
    if context[:current_admin].nil?
      @model.paid = false
      @model.discount = 0
      @model.discount_message = nil
      @model.memo = nil
    end
  end

  after_save do
    BookingMailer.booking_email(@model).deliver_now
  end
end
