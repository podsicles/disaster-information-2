class AddDeletedAtToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :deleted_at, :datetime, default: nil
  end
end
