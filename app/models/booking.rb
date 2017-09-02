class Booking < ActiveRecord::Base
  attr_accessor :send_email
  # Scopes
  default_scope { where(deleted_at: nil)}

  # Relations
  belongs_to :event
  validates :event, presence: true
  
  # Validations
  validates :booking_type, inclusion: {in: %w(private business)}, presence: true
  validates :name, presence: {message: "Du måste ange ett namn"}
  validates :contact_person, presence: {message: "Du måste ange en kontaktperson"}, if: :is_business
  validates :email, presence: {message: "Du måste ange en giltig e-postadress"}, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: 'E-post adressen är inte korrekt formaterad', allow_nil: true}
  validates :phone_nr, presence: {message: "Du måste ange ett telefonnummer"}, format: {with: /\A[0-9]+\z/i, message: "Ange telefonnumret med enbart siffror", allow_nil: true}
  validates :tickets, presence: {message: "Du måste ange antal biljetter"}, numericality: {only_integer: true, greater_than: 0, message: "Antal biljetter måste vara större än 0", allow_nil: true} 
  validates :token, presence: true
  before_validation :ensure_token
  validate :enough_tickets_available
  validate :validate_discount
  validates :discount, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Rabatt måste vara ett heltal", allow_nil: true}
  validates :due_date, presence: true
  validates :delivery_date, presence: true

  # Set booking on related event
  def event
    event = super
    if event.present?
      event.booking = self
    end
    return event
  end

  #legacy due_date
  def due_date
    if @due_date.nil?
      created_at + (invoice_days).days
    else
      @due_date
    end
  end

  # legacy delivery date
  def delivery_date
    if @delivery_date.nil?
      created_at
    else
      @delivery_date
    end
  end

  def ensure_token
    if self.token.blank?
      self.token = generate_token
    end
  end

  def validate_discount
    if discount.present? && discount > event.price
      errors.add(:discount, "Rabatt kan inte vara högre än priset")
    end
  end

  def enough_tickets_available
    if event.present? && tickets.present? && event.seats_left < tickets
      errors.add(:tickets, "Det finns inte tillräckligt många platser kvar.")
    end
  end

  def generate_token
    loop do
      tok = SecureRandom.hex(10)
      break tok unless Booking.where(token: tok).first
    end
  end

  def is_business
    self.booking_type == 'business'
  end

  def is_private
    self.booking_type == 'private'
  end
def reference
    if is_business
      return self.contact_person
    else
      return name
    end
  end

  def destroy
    self.update_attribute('deleted_at', DateTime.now)
  end

  # Number of days crom booking creation until invoice has to be paid
  def invoice_days
    if is_business
      return 20
    else
      return 10
    end
  end

  def invoice_days_calculated
    return (self.due_date.to_date - self.delivery_date.to_date).to_i
  end

  # Total price of booking after discount including tax
  def total_price
    return (self.tickets * price_actual).round(2)
  end

  def total_net_price
    return (net_price * tickets).round(2)
  end

  def total_tax
    return (total_tax_ticket * tickets).round(2)
  end

  # Total tax of booking after discount
  def tax_actual(tax)
    if discount.present?
      return tax - discount * event.tax_share(tax)
    else
      return tax
    end
  end 
  #
  # Returns the actual taxes for a given sum and percentage in money
  def tax_sum(tax, tax_percent)
    (tax - (tax / (1 + tax_percent))).round(2)
  end

  # The total taxes sum derived from 25% tax rate for a booking
  def tax25_sum
    tax_sum(tax_actual(event.tax25), 0.25)
  end

  def tax12_sum
    tax_sum(tax_actual(event.tax12), 0.12)
  end

  def tax6_sum
    tax_sum(tax_actual(event.tax6), 0.06)
  end

  def total_tax25_net
    return (tax25_net * tickets).round(2)
  end

  def total_tax12_net
    return (tax12_net * tickets).round(2)
  end

  def total_tax6_net
    return (tax6_net * tickets).round(2)
  end

  def total_tax25_sum
    return (tax25_sum * tickets).round(2)
  end

  def total_tax12_sum
    return (tax12_sum * tickets).round(2)
  end

  def total_tax6_sum
    return (tax6_sum * tickets).round(2)
  end

  def tax_net(tax, tax_percent)
    tax / (1 + tax_percent)
  end

  # Sum using 25% tax rate excluding taxes per ticket
  def tax25_net
    tax_net(tax_actual(event.tax25), 0.25)
  end

  # Sum using 12% tax rate excluding taxes per ticket
  def tax12_net
    tax_net(tax_actual(event.tax12), 0.12)
  end

  # Sum using 6% tax rate excluding taxes per ticket
  def tax6_net
    tax_net(tax_actual(event.tax6), 0.06)
  end

  # Returns the discount excluding tax
  def discount_net
    return self.discount - self.discount * event.tax_share_25 * 0.25 - self.discount * event.tax_share_12 * 0.12 - self.discount * event.tax_share_6 * 0.06
  end

  # Tax per ticket for booking
  def total_tax_booking
    (total_tax25_sum + total_tax12_sum + total_tax6_sum).round(2)
  end
  #
  # Tax per ticket for booking
  def total_tax_ticket
    (tax25_sum + tax12_sum + tax6_sum).round(2)
  end

  # Price per ticket excluding tax after discount
  def net_price
    price_actual - total_tax_ticket
  end

  # Price per ticket including tax after discount
  def price_actual
    if discount.present?
      return event.price - discount
    else
      return event.price
    end
  end

end
