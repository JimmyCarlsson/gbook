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
    bounding_box [40, 210], width: 200 do
      taxes_box
    end
    bounding_box [330,190], width: 200 do
      to_pay_box
    end
    bounding_box [30,115], width: 500 do
      payment_instructions
    end
    bounding_box [30,80], width: 200 do
      address
    end
    bounding_box [250,80], width: 200 do
      bank_info
    end
    bounding_box [400,80], width: 200 do
      tax_info
    end
  end

  def logo
    logopath = "#{Rails.root}/app/assets/images/grebbans-black-invoice.png"
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
      draw_text @booking.delivery_date.strftime('%F'), size: 16, at: [width+@spacing+15,-25]
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
      draw_text @booking.address_street, size: 12, at: [12, -40]
      draw_text @booking.address_zip, size: 12, at: [12, -55]
      draw_text @booking.address_city, size: 12, at: [12, -70]
      draw_text @booking.email, size: 12, at: [12, -90]
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
      ["Er referens", @booking.reference, "Vår referens", "Anna Rockenstierna"], 
      ["Betalningsvillkor", "#{@booking.invoice_days_calculated} dagar netto", "Förfallodatum", @booking.due_date.strftime('%F')],
      ["Leveransdatum", @booking.delivery_date.strftime('%F'), "Dröjsmålsränta", "8%"]
    ]
  end

  def invoice_table
    width = 500
    height = 35
    height2 = 250
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width, height, @corners
    end
    bounding_box [@x+20,@y-0], width: 450 do
      table [["Benämning", "Lev ant", "á-pris", "Rabatt á-pris", "Summa"]],column_widths: [200, 50, 75, 50], width: 450 do
        cells.borders = []
        columns(4).align = :right
      end
    end
    @y -= (height + @spacing + 10)
    translate(@x,@y) do
      stroke_rounded_rectangle [0,0], width, height2, @corners
    end
    bounding_box [@x+20, @y-10], width: 450 do
      table invoice_rows, column_widths: [200, 50, 75, 50], cell_style: {inline_format: true}, width: 450 do
        cells.borders = []
        columns(4).align = :right
      end
    end

    @y -= height2

  end

  def invoice_rows
    invoice_rows = []
    invoice_rows << tickets_invoice_row
    @booking.order_rows.each do |order_row|
      invoice_rows << order_row_invoice_row(order_row)
    end
    return invoice_rows
  end

  def tickets_invoice_row
      [
       "#{@booking.event.name} #{@booking.event.date.strftime('%F')}", 
       @booking.tickets, 
       format_number(@booking.event.price), 
       (@booking.discount && @booking.discount.positive?) ? format_number(@booking.discount) : "",
       format_number(@booking.total_price_tickets)
      ]
  end

  def order_row_invoice_row(order_row)
    [
     order_row.name,
     order_row.amount,
     format_number(order_row.price),
     '',
     format_number(order_row.total_price)
    ] 
  end

 # def invoice_rows_old #this version includes special treatment of businesses with additional tax information. This has been disabled via booking.rb for now.
 #   [
 #     ["#{@booking.event.name} #{@booking.event.date.strftime('%F')}", 
 #      @booking.tickets, 
 #      @booking.is_business_flagged ? business_price_info(price_sum: @booking.event.net_price, food_sum: @booking.event.tax12_net, show_sum: @booking.event.tax6_net) : format_number(@booking.event.price), 
 #      (@booking.discount && @booking.discount.positive?) ? (@booking.is_business_flagged ? format_number(@booking.discount_net) : format_number(@booking.discount)) : "", 
 #      @booking.is_business_flagged ? business_price_info(price_sum: @booking.total_net_price, food_sum: @booking.total_tax12_net, show_sum: @booking.total_tax6_net) : format_number(@booking.total_price)]
 #   ]
 # end

  def business_price_info(price_sum:, food_sum:, show_sum:)
    str = "#{format_number(price_sum)}"
    if @booking.event.tax12 + @booking.event.tax6 > 0
      str += "<br/><font size='10'>Varav:<br/>"
      if @booking.event.tax12 > 0
        str += "Mat: #{format_number(food_sum)}"
      end
      if @booking.event.tax6 > 0
      str += "<br/>Show: #{format_number(show_sum)}"
      end
    end
    return str
  end

  def taxes_box
    font_size 10
    table taxes_data, cell_style: {inline_format: true}do
      columns(0).align = :right
      columns(1).align = :right
      cells.borders = []
    end
  end

  def taxes_data
    array = []
    if @booking.total_tax25_sum > 0
      #array << ["Momspl belopp 25%", format_number(@booking.total_tax25_net)]
      array << ["Moms kr 25%", format_number(@booking.total_tax25_sum)]
    end

    if @booking.total_tax12_sum > 0
      #array << ["Momspl belopp 12%", format_number(@booking.total_tax12_net)]
      array << ["Moms kr 12%", format_number(@booking.total_tax12_sum)]
    end

    if @booking.total_tax6_sum > 0
      #array << ["Momspl belopp 6%", format_number(@booking.total_tax6_net)]
      array <<["Moms kr 6%", format_number(@booking.total_tax6_sum)]
    end
    array << ["<b>Moms kr totalt</b>", "<b>" + format_number(@booking.total_tax) + "</b>"]
    return array
  end

  def to_pay_box
    font_size 12
    table [["Netto", format_number(@booking.total_net_price)],["<font size='15'><b>ATT BETALA</b></font>", "<font size='15'><b>" + format_number(@booking.total_price) + "</b></font>"]], cell_style: {inline_format: true} do
      columns(0).align = :right
      columns(1).align = :right
      cells.borders = []
    end
  end

  def payment_instructions
    text "Betalningsanvisning: För över #{format_number(@booking.total_price)}:- till BankGiro 759-5416 , ange 'Fakturanr: #{@booking.id}' i meddelandefältet.", style: :bold
  end

  def address
    text "Adress", size: 10
    text "Rockenstierna Nöjesproduktion AB"
    text "Kapellvägen 26, 544 92 Hjo"
   #text "544 92 Hjo"
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

  def format_number(number)
    return ('%.2f' % number).gsub('.', ',')
  end

end
