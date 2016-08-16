class Event < ActiveRecord::Base
  attr_accessor :discount
  # Scopes
  default_scope { where(deleted_at: nil)}
  # Relations
  has_many :bookings
  # Validations
  validates :name, presence: {message: "Ett namn måste anges"}
  validates :date, presence: {message: "Ett datum och klockslag måste anges"}
  validates :price, presence: {message: "Ett pris måste anges" }, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :seats, presence: {message: "Antal platser måste anges"}, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Antal platser måste vara ett heltal"}
  validates :tax25, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :tax12, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :tax6, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validate :sum_of_taxvalues_equals_price
  validate :date_cannot_be_in_the_past
  validate :price_cannot_be_changed, if: :has_bookings, on: :update

  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "Datum kan inte anges bakåt i tiden")
    end
  end

  def has_bookings
    bookings.present?
  end

  def price_cannot_be_changed
    if price_changed? && self.persisted? && bookings.present?
      errors.add(:price, "Priset kan inte uppdateras eftersom det finns bokningar (#{bookings.count}st)")
    end
  end

  def sum_of_taxvalues_equals_price
    taxvalues_sum = tax25 + tax12 + tax6
    if taxvalues_sum != price
      errors.add(:price, "Totalvärdet för skattesatserna(#{taxvalues_sum}) matchar inte priset(#{price})")
    end
  end

  def destroy
    self.update_attribute('deleted_at', DateTime.now)
  end

  def booked_seats
    booked_seats = 0
    bookings.each do |booking|
      booked_seats += booking.tickets
    end
    return booked_seats
  end

  def seats_left
    self.seats - booked_seats
  end

  def availability_string
    i = seats_left
    if i > 50
      return "plenty"
    elsif i > 20
      return "some"
    elsif i > 0
      return "few"
    elsif i == 0
      return "none"
    end
  end

  def tax_actual(tax)
    return tax - discount * tax_share(tax) if discount.present?
    return tax
  end 

  # Returns the actual taxes in money
  def tax_sum(tax, tax_percent)
    (tax - (tax / (1 + tax_percent))).round(2)
  end

  def tax25_sum
    tax_sum(tax_actual(tax25), 0.25)
  end

  def tax12_sum
    tax_sum(tax_actual(tax12), 0.12)
  end

  def tax6_sum
    tax_sum(tax_actual(tax6), 0.06)
  end

  def tax_net(tax, tax_percent)
    tax / (1 + tax_percent)
  end

  def tax25_net
    tax_net(tax_actual(tax25), 0.25)
  end

  def tax12_net
    tax_net(tax_actual(tax12), 0.12)
  end

  def tax6_net
    tax_net(tax_actual(tax6), 0.06)
  end

  # Returns the share in decimals per tax count
  def tax_share(tax)
    tax.to_f / price
  end

  def total_tax
    (tax25_sum + tax12_sum + tax6_sum).round(2)
  end

  def net_price
    price_actual - total_tax
  end

  def price_actual
    discount = self.discount || 0
    price - discount
  end
end
