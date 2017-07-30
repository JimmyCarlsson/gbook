class BookingMailer < ApplicationMailer
  default from: 'noreply@grebbans.se'
 
  def booking_email(booking)
    @booking = booking
    mail(to: @booking.email, subject: 'Din bokningsbekräftelse!')
  end
end
