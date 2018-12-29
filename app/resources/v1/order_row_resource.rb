require 'pp'

class V1::OrderRowResource < JSONAPI::Resource
  attributes :name, :created_at, :updated_at, :description, :price, :tax6, :tax12, :tax25, :total_price, :total_net_price, :amount

  has_one :booking

  def self.updatable_fields(context)
    non_updateables =  [:created_at, :updated_at, :total_price]

    return super - non_updateables
  end

  def self.creatable_fields(context)
    # These should never be updated through json api
    non_creatables =  [:created_at, :updated_at, :total_price]
    return super - non_creatables 
  end

  def self.fetchable_fields(context)
    if context[:current_admin].present?
      super
    else
      super - []
    end
  end

end
