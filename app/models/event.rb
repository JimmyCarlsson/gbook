class Event < ActiveRecord::Base
  # Scopes
  default_scope { where(deleted_at: nil)}
  # Relations
  has_many :bookings
  # Validations
  validates :name, presence: {message: "Ett namn måste anges"}
  validates :date, presence: {message: "Ett datum och klockslag måste anges"}
  validates :price, presence: {message: "Ett pris måste anges" }, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :seats, presence: {message: "Antal platser måste anges"}, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Antal platser måste vara ett heltal"}

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
end
