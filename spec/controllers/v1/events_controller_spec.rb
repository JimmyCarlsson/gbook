require 'rails_helper'

RSpec.describe V1::EventsController, type: :controller do
  describe "GET index" do
    context "current user is admin" do
      before(:each) do
        @past_event = create(:event, :skip_validate, date: DateTime.now - 1.week)
        @coming_event = create(:event, date: DateTime.now + 1.week)
      end

      
      context "historical queryparam is set to false" do
        it "returns all future events" do
          sign_in_admin
          get :index, historical: "false"

          expect(response.status).to eq 200
          expect(parsed_json['data'].size).to eq 1
          expect(parsed_json['data'].first['id'].to_i).to eq @coming_event.id
        end

      end

      context "historical queryparam is set to true" do
        it "returns all events" do
          sign_in_admin
          get :index, historical: "true"

          expect(response.status).to eq 200
          expect(parsed_json['data'].size).to eq 1
          expect(parsed_json['data'].first['id'].to_i).to eq @past_event.id
        end
      end
    end

    context "current user is NOT an admin" do
      before(:each) do
        @past_event = create(:event, :skip_validate, date: DateTime.now - 1.week)
        @coming_event = create(:event, date: DateTime.now + 1.week)
      end
      context "historical queryparam is set to false" do
        it "returns all future events" do
          get :index, historical: "false"

          expect(response.status).to eq 200
          expect(parsed_json['data'].size).to eq 1
          expect(parsed_json['data'].first['id'].to_i).to eq @coming_event.id
        end

      end

      context "historical queryparam is set to true" do
        it "returns all future events" do
          get :index, historical: "true"

          expect(response.status).to eq 200
          expect(parsed_json['data'].size).to eq 1
          expect(parsed_json['data'].first['id'].to_i).to eq @coming_event.id
        end
      end
    end

    context "an event is hidden" do
      it "is visible for admins" do
        sign_in_admin
        hidden_event = create(:event, date: DateTime.now + 1.week, hidden: true)

        get :index

        expect(response.status).to eq 200
        expect(parsed_json['data'].size).to eq 1
        expect(parsed_json['data'].first['id'].to_i).to eq hidden_event.id
      end
      it "is not visible for regular users" do
        hidden_event = create(:event, date: DateTime.now + 1.week, hidden: true)

        get :index

        expect(response.status).to eq 200
        expect(parsed_json['data'].size).to eq 0
      end
    end
  end
end
