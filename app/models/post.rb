class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  mount_uploader :image, ImageUploader
  validates :content_or_image, presence: true

  private

  def content_or_image
    content.presence || image.presence
  end
end
