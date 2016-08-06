class AddDeletedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :deleted_at, :datetime, :default => nil
  end
end
