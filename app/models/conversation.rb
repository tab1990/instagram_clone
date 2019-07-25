class Conversation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :recipient_id

  # 二者の会話の履歴を探す
  scope :between, lambda { |sender_id, recipient_id|
    where('(conversations.sender_id = ? AND conversations.recipient_id =? ) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)', sender_id, recipient_id, recipient_id, sender_id)
  }

  # 会話の相手を探す
  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end
end
