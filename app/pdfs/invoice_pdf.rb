class InvoicePdf < Prawn::Document

  def initialize(booking)
    super()
    @booking = booking
    logo
    @corners = 5
    @spacing = 10
    @x = 250
    @y = 730
    invoice_header
    invoice_nr
  end

  def logo
    logopath = "#{Rails.root}/app/assets/images/logo.png"
    image logopath
  end

  def invoice_header
    width = 250
    height = 40
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width,height,@corners
      draw_text "Faktura", size: 22, at: [10,-27]
    end
    @y -= (height + 5)
  end

  def invoice_nr
    width = 120
    height = 30
    width2 = 120
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width, height, @corners
      draw_text "Fakt nr:", size: 10, at: [10,-10]
      draw_text @booking.id, size: 16, at: [50,-25]
      stroke_rounded_rectangle [width+@spacing,0], width2, height, @corners
      draw_text "Fakturadatum:", size: 10, at: [width+@spacing+10,-10]
      draw_text @booking.created_at.strftime('%F'), size: 16, at: [width+@spacing+15,-25]
    end
    
  end

end
