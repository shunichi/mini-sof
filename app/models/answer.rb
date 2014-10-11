class Answer < ActiveRecord::Base
  include VotableMethods

  belongs_to :user
  belongs_to :question, counter_cache: true
  validates :user_id, :question_id, :body, presence: true
end
