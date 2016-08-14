class Booking < ActiveRecord::Base
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

  def ensure_token
    if self.token.blank?
      self.token = generate_token
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

  # Date when invoice is due
  def due_date
    DateTime.parse(self.created_at.to_s) + invoice_days
  end

  # Number of days crom booking creation until invoice has to be paid
  def invoice_days
    if is_business
      return 20
    else
      return 10
    end
  end

  def total_price
    return (self.tickets * event.price).round(2)
  end

  def total_net_price
    return (event.net_price * tickets).round(2)
  end

  def total_tax
    return (event.total_tax * tickets).round(2)
  end

  def total_tax25_net
    return (event.tax25_net * tickets).round(2)
  end

  def total_tax12_net
    return (event.tax12_net * tickets).round(2)
  end

  def total_tax6_net
    return (event.tax6_net * tickets).round(2)
  end

  def total_tax25_sum
    return (event.tax25_sum * tickets).round(2)
  end

  def total_tax12_sum
    return (event.tax12_sum * tickets).round(2)
  end

  def total_tax6_sum
    return (event.tax6_sum * tickets).round(2)
  end

end
