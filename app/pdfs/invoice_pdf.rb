class InvoicePdf < Prawn::Document

  def initialize(booking)
    super()
    @booking = booking
    text "This is an  invoice for #{@booking.id} #{@booking.token}"
  end

end
