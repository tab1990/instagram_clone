class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates_presence_of :body, :conversation_id, :user_id

  # メッセージを投稿した時間を所定のフォーマットに変換する
  def message_time
    created_at.strftime('%m/%d/%y at %l:%M %p')
  end
end
