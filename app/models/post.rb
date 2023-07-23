class Post < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :title, presence: true
  validates :content, presence: true
  validates :address_province_id, presence: true

  has_many :comments
  has_many :post_category_ships
  has_many :categories, through: :post_category_ships

  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  def destroy
    update(deleted_at: Time.now)
  end

  private

  def generate_short_url
    self.short_url = format('%04d', rand(10_000))
  end
end