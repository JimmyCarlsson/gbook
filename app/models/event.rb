class Event < ActiveRecord::Base
  # Scopes
  default_scope { where(deleted_at: nil)}
  # Validations
  validates :name, presence: {message: "Ett namn måste anges"}
  validates :date, presence: {message: "Ett datum och klockslag måste anges"}
  validates :price, presence: {message: "Ett pris måste anges" }, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Priset måste vara ett heltal"}
  validates :seats, presence: {message: "Antal platser måste anges"}, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: "Antal platser måste vara ett heltal"}

  def destroy
    self.update_attribute('deleted_at', DateTime.now)
  end
end
