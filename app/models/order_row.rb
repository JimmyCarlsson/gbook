class OrderRow < ActiveRecord::Base
  # Relations
  belongs_to :booking
  validates :booking, presence: true
  
  # Validations
  validates :name, presence: {message: "Ett namn måste anges"}
  validates :amount, presence: {message: "Du måste ange ett antal"}, numericality: {only_integer: true, greater_than: 0, message: "Antal måste vara större än 0"} 
  validates :price, presence: {message: "Ett pris måste anges" }, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :tax25, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :tax12, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :tax6, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validate :sum_of_taxvalues_equals_price

  def sum_of_taxvalues_equals_price
    taxvalues_sum = tax25 + tax12 + tax6
    if taxvalues_sum != price
      errors.add(:price, "Totalvärdet för skattesatserna(#{taxvalues_sum}) matchar inte priset(#{price})")
    end
  end

  def total_price
    return price * amount
  end

  # Total price excl. tax
  def total_net_price
    return total_price - total_tax
  end

  # Total tax for orderrow
  def total_tax
    tax_sum_total * amount
  end

  # Returns the actual taxes for a given sum and percentage in money
  def tax_sum(tax, tax_percent)
    (tax - (tax / (1 + tax_percent))).round(2)
  end

  # The total taxes sum derived from 25% tax rate for an amount of ONE
  def tax25_sum
    tax_sum(tax25, 0.25)
  end

  def tax12_sum
    tax_sum(tax12, 0.12)
  end

  def tax6_sum
    tax_sum(tax6, 0.06)
  end

  # Total tax for an amount of ONE
  def tax_sum_total
    tax25_sum + tax12_sum + tax6_sum
  end


end
