class Question < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 250 }
  validates :body, presence: true
end
