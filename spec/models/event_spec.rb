require 'rails_helper'

RSpec.describe Event, type: :model do

  # Fields
  subject {build(:event)}
  describe "name" do
    it {should validate_presence_of(:name).with_message("Ett namn måste anges")}
  end

  describe "description" do
    it {should allow_value(nil).for(:description)}
  end

  describe "date" do
    it {should validate_presence_of(:date).with_message("Ett datum och klockslag måste anges")}
  end

  describe "price" do
    it {should validate_presence_of(:price).with_message("Ett pris måste anges")}
    it {should validate_numericality_of(:price).is_greater_than_or_equal_to(0).with_message("Priset måste vara ett heltal")}
    it "should validate that the price equals the sum of tax values" do
      event = build(:event, price: 100, tax25: 20, tax12: 20, tax6: 20)

      expect(event.valid?).to be false
      expect(event.errors.messages[:price]).to include("Totalvärdet för skattesatserna(60) matchar inte priset(100)")
    end
  end
  
  describe "seats" do
    it {should validate_presence_of(:seats).with_message("Antal platser måste anges")}
    it {should validate_numericality_of(:seats).is_greater_than_or_equal_to(0).with_message("Antal platser måste vara ett heltal")}
  end

  describe "tax25" do
    it {should validate_numericality_of(:tax25).is_greater_than_or_equal_to(0).with_message("Priset måste vara ett heltal")}
  end

  describe "tax12" do
    it {should validate_numericality_of(:tax12).is_greater_than_or_equal_to(0).with_message("Priset måste vara ett heltal")}
  end

  describe "tax6" do
    it {should validate_numericality_of(:tax6).is_greater_than_or_equal_to(0).with_message("Priset måste vara ett heltal")}
  end

  # Relations
  describe "bookings" do
    it {should have_many(:bookings)}
  end

  # Methods
  describe "destroy" do
    it "should set deleted_at flag and keep object in database" do
      event = create(:event)

      event.destroy

      expect(event.deleted_at).to_not be nil

      event2 = Event.unscoped.find(event.id)

      expect(event2).to_not be nil
    end
  end

  describe "booked_seats" do
    it "should return the accumulated sum of bookings" do
      event = build(:event)
      event.bookings << build(:booking, event: event, tickets: 3)
      event.bookings << build(:booking, event: event, tickets: 2)

      expect(event.booked_seats).to eq 5
    end
  end

  describe "seats_left" do
    it "should return the seats that have not yet been booked" do
      event = build(:event, seats: 10)
      event.bookings << build(:booking, event: event, tickets: 4)
      event.bookings << build(:booking, event: event, tickets: 2)

      expect(event.seats_left).to eq 4
    end
  end

  describe "tax25_sum" do
    it "should return the tax sum for tax25" do
      event = build(:event, tax25: 40)

      expect(event.tax25_sum).to eq 10
    end
  end

  describe "tax12_sum" do
    it "should return the tax sum for tax12" do
      event = build(:event, tax12: 40)

      expect(event.tax12_sum).to eq 4.8
    end
  end

  describe "tax6_sum" do
    it "should return the tax sum for tax6" do
      event = build(:event, tax6: 40)

      expect(event.tax6_sum).to eq 2.4
    end
  end

  describe "total_tax" do
    it "should return the full tax sum" do
      event = build(:event, price: 100, tax6: 20, tax12: 20, tax25: 60)

      expect(event.total_tax).to eq 18.6
    end
  end

  describe "net_price" do
    it "should return the price excluding taxes" do
      event = build(:event, price: 100, tax6: 20, tax12: 20, tax25: 60)

      expect(event.net_price).to eq 81.4
    end
  end
end
