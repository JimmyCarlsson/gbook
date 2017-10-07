class Event < ActiveRecord::Base
  attr_accessor :booking
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
      if self.booking.present? && self.booking.id == booking.id
        next
      end
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

  # Fraction of price using a 25% tax rate (format: 0.38)
  def tax_share_25
    tax_share(tax25)
  end

  # Fraction of price using a 12% tax rate (format: 0.38)
  def tax_share_12
    tax_share(tax12)
  end

  # Fraction of price using a 6% tax rate (format: 0.38)
  def tax_share_6
    tax_share(tax6)
  end

  # Returns the actual taxes for a given sum and percentage in money
  def tax_sum(tax, tax_percent)
    (tax - (tax / (1 + tax_percent))).round(2)
  end

  # The total taxes sum derived from 25% tax rate for a booking
  def tax25_sum
    tax_sum(tax25, 0.25)
  end

  def tax12_sum
    tax_sum(tax12, 0.12)
  end

  def tax6_sum
    tax_sum(tax6, 0.06)
  end

  def tax_net(tax, tax_percent)
    tax / (1 + tax_percent)
  end

  # Sum using 25% tax rate excluding taxes per ticket
  def tax25_net
    tax_net(tax25, 0.25)
  end

  # Sum using 12% tax rate excluding taxes per ticket
  def tax12_net
    tax_net(tax12, 0.12)
  end

  # Sum using 6% tax rate excluding taxes per ticket
  def tax6_net
    tax_net(tax6, 0.06)
  end

  # Returns the share in decimals per tax count
  def tax_share(tax)
    tax.to_f / price
  end

  def total_tax
    (tax25_sum + tax12_sum + tax6_sum).round(2)
  end

  def net_price
    price - total_tax
  end

  # Takes a book and adds a sheet for the event
  def add_as_sheet(book:)

    sheet = book.create_worksheet

    sheet.name = "#{name} #{date.strftime('%F')}"
    row = sheet.row(1)
    row.push "Event: "
    row.push name + " " + date.strftime('%F')
    row = sheet.row(2)
    row.push "Uttag datum:"
    row.push DateTime.now.strftime('%FT%R')
    row = sheet.row(3)
    row.push "Bokningar:"
    row = sheet.row(4)
    row.push "Id", "Biljetter", "Namn", "Bokades", "Epost", "Telefon", "Kontaktperson", "Betalat", "Meddelande", "Notering", "Rabatt", "Rabattmeddelande"
    bookings.each_with_index do |booking, index|
      row = sheet.row(5+index)
      row.push booking.id, booking.tickets, booking.name, booking.created_at.strftime('%FT%R'), booking.email, booking.phone_nr, booking.contact_person, booking.paid, booking.message, booking.memo, booking.discount, booking.discount_message
    end

    return book
  end
end
