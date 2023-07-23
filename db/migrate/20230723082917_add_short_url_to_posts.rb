class AddShortUrlToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :short_url, :string
    add_index :posts, :short_url, unique: true
  end
end
