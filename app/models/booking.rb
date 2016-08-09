class Booking < ActiveRecord::Base

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

end
