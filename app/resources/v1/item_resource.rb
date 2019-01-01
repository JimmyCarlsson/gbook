class V1::ItemResource < JSONAPI::Resource
  attributes :name, :created_at, :updated_at, :description, :price, :tax6, :tax12, :tax25, :net_price

  def self.updatable_fields(context)
    if !context[:current_admin].present?
      return []
    end
    non_updateables =  [:created_at, :updated_at, :net_price]

    return super - non_updateables
  end

  def self.creatable_fields(context)
    if !context[:current_admin].present?
      return []
    end
    # These should never be updated through json api
    non_creatables =  [:created_at, :updated_at, :net__price]
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
