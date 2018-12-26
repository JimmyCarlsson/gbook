require 'pp'

class V1::BookingResource < JSONAPI::Resource
  attributes :name, :booking_type, :contact_person, :email, :tickets, :phone_nr, :token, :created_at, :updated_at, :message, :discount, :discount_message, :memo, :paid, :total_price, :send_email, :due_date, :delivery_date, :address_street, :address_zip, :address_city

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
      @model.send_email = nil

      @model.delivery_date = Date.today
      
      invoice_days = @model.invoice_days 
      if Date.today + invoice_days > @model.event.date.to_date
        invoice_days = @model.event.date.to_date - Date.today
        if invoice_days < 0
          invoice_days = 0
        end
      end

      @model.due_date = Date.today + invoice_days
    end
  end

  after_save do
    # Only send email if booking created by customer, or admin specified that it should be sent
    if context[:current_admin].nil? || @model.send_email == true
      BookingMailer.booking_email(@model).deliver_now
    end
  end
end
