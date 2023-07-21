class AddAddressToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :address, :string
    add_reference :posts, :address_region
    add_reference :posts, :address_province
    add_reference :posts, :address_city
    add_reference :posts, :address_barangay
  end
end
