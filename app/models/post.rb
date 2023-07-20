class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  has_many :comments
  has_many :categories

  belongs_to :user
end