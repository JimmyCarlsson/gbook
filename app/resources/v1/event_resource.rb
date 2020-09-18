class V1::EventResource < JSONAPI::Resource
  attributes :name, :description, :date, :price, :seats, :availability_string, :tax6, :tax12, :tax25, :total_tax, :net_price, :booked_seats, :hidden, :items, :ticket_limit_lower, :ticket_limit_higher, :ticket_limit_lower_msg, :ticket_limit_higher_msg

  has_many :bookings

  def self.updatable_fields(context)
    super - [:availability_string, :total_tax, :net_price]
  end

  def self.creatable_fields(context)
    super - [:availability_string, :total_tax, :net_price]
  end

  def self.fetchable_fields(context)
    if context[:current_admin].present?
      super
    else
      super - [:seats, :booked_seats]
    end
  end
end
