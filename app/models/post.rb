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

  def destroy
    update(deleted_at: Time.now)
  end
end