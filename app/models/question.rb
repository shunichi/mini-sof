class Question < ActiveRecord::Base
  acts_as_votable
  include VotableMethods

  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :accepted_answer, class_name: 'Answer', foreign_key: :answer_id

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 250 }
  validates :body, presence: true
end
