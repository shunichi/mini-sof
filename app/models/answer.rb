class Answer < ActiveRecord::Base
  acts_as_votable
  include VotableMethods

  belongs_to :user
  belongs_to :question
  validates :user_id, :question_id, :body, presence: true
end
