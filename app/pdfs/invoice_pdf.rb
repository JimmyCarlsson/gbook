require 'prawn'
require 'prawn/table'
class InvoicePdf < Prawn::Document

  def initialize(booking)
    super()
    @booking = booking
    logo
    @corners = 5
    @spacing = 5
    @x = 250
    @y = 730
    invoice_header
    invoice_nr
    billing_address
    @x = 20
    info_table
    @y -= 50
    invoice_table
    to_pay_box
    bounding_box [30,120], width: 500 do
      payment_instructions
    end
    bounding_box [30,80], width: 200 do
      address
    end
    bounding_box [210,80], width: 200 do
      bank_info
    end
    bounding_box [400,80], width: 200 do
      tax_info
    end
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
    @y -= (height + @spacing)
  end

  def invoice_nr
    width = 123
    height = 30
    width2 = 122
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width, height, @corners
      draw_text "Faktura nr", size: 10, at: [10,-10]
      draw_text @booking.id, size: 16, at: [50,-25]
      stroke_rounded_rectangle [width+@spacing,0], width2, height, @corners
      draw_text "Fakturadatum", size: 10, at: [width+@spacing+10,-10]
      draw_text @booking.created_at.strftime('%F'), size: 16, at: [width+@spacing+15,-25]
    end
    @y -= (height + @spacing)
  end

  def billing_address
    width = 250
    height = 100
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width, height, @corners
      draw_text "Fakturaadress", size: 10, at: [10,-10]
      draw_text @booking.name, size: 12, at: [12, -25]
      draw_text @booking.email, size: 12, at: [12, -60]
    end
    @y -= height + @spacing
  end

  def info_table
    font_size 12
    table info_table_rows, width: 500 do
      cells.borders = []
    end

  end

  def info_table_rows
    [
      ["Er referens", @booking.reference, "Vår referens", "Tomas Rockenstierna"], 
      ["Betalningsvillkor", "10 dagar netto", "Förfallodatum", @booking.due_date.strftime('%F')],
      ["Leveransdatum", @booking.created_at.strftime('%F'), "Dröjsmålsränta", "8%"]
    ]
  end

  def invoice_table
    width = 500
    height = 35
    height2 = 250
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width, height, @corners
    end
    bounding_box [@x+20,@y-5], width: 450 do
      table [["Benämning", "Lev ant", "á-pris", "Rabatt", "Summa"]],column_widths: [225, 50, 50, 50], width: 450 do
        cells.borders = []
        columns(4).align = :right
      end
    end
    @y -= (height + @spacing + 10)
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width, height2, @corners
    end
    bounding_box [@x+20, @y-20], width: 450 do
      table invoice_rows, column_widths: [225, 50, 50, 50], width: 450 do
        cells.borders = []
        columns(4).align = :right
      end
    end

    @y -= height2

  end

  def invoice_rows
    [
      ["#{@booking.event.name} #{@booking.event.date.strftime('%F')}", @booking.tickets, @booking.event.price, "", @booking.total_price]
    ]
  end

  def to_pay_box
    draw_text "ATT BETALA", at: [430, @y+40]
    draw_text @booking.total_price_string, at: [460, @y+20]
  end

  def payment_instructions
    text "Betalningsanvisning: För över #{@booking.total_price}:- till BankGiro 759-5416 , ange 'Fakturanr: #{@booking.id}' i meddelandefältet.", style: :bold
  end

  def address
    text "Adress", size: 10
    text "Kapellvägen 26"
    text "544 92 Hjo"
    move_down 5
    text "Företagets säte", size: 10
    text "Västra Götalands Län"
  end

  def bank_info
    text "Bankgiro", size: 10
    text "759-5416"
    move_down 5
    text "Organisationsnummer", size: 10
    text "556987-0727"
  end

  def tax_info
    text "Momsreg.nr", size: 10
    text "SE556987072701"
    text "Godkänd för F-skatt"
  end

end
