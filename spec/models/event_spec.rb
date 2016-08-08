require 'rails_helper'

RSpec.describe Event, type: :model do

  # Fields
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
  end
  
  describe "seats" do
    it {should validate_presence_of(:seats).with_message("Antal platser måste anges")}
    it {should validate_numericality_of(:seats).is_greater_than_or_equal_to(0).with_message("Antal platser måste vara ett heltal")}
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
end
