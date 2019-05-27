class User < ApplicationRecord
  has_many :posts,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :favorite_posts,through: :favorites,source: :post
  mount_uploader :image, ImageUploader
  before_validation {email.downcase!}
  validates :name,presence: true,length:{maximum: 30}
  validates :email,presence: true,length:{maximum: 255},format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },uniqueness: true
  has_secure_password
  validates :password,presence: true,length: {minimum: 6},allow_nil: true

  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

    #指定のユーザをフォローする
  def follow!(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  #フォローしているかどうかを確認する
  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

end
