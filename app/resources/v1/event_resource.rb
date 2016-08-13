class V1::EventResource < JSONAPI::Resource
  attributes :name, :description, :date, :price, :seats, :availability_string, :tax6, :tax12, :tax25, :total_tax, :net_price

  has_many :bookings

  def self.updatable_fields(context)
    super - [:availability_string, :total_tax, :net_price]
  end

  def self.creatable_fields(context)
    super - [:availability_string, :total_tax, :net_price]
  end
end
