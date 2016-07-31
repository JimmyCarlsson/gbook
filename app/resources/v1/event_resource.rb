class V1::EventResource < JSONAPI::Resource
  attributes :name, :description, :date, :price, :seats
end
