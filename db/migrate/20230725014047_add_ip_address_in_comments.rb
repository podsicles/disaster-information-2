class AddIpAddressInComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :ip_address, :string
  end
end
