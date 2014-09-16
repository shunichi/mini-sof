class Question < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :accepted_answer, class_name: 'Answer', foreign_key: :answer_id

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 250 }
  validates :body, presence: true

  def votes_by(user)
    votes_for.where(voter: user)
  end

  def toggle_vote_up(user)
    if votes_by(user).up.any?
      unvote_by user
    else
      upvote_by user
    end
  end

  def toggle_vote_down(user)
    if votes_by(user).down.any?
      unvote_by user
    else
      downvote_by user
    end
  end

  def vote_sum
    get_upvotes.size - get_downvotes.size
  end
end
