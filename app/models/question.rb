class Question < ActiveRecord::Base
  acts_as_votable
  include VotableMethods

  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :accepted_answer, class_name: 'Answer', foreign_key: :answer_id

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 250 }
  validates :body, presence: true

  def self.sorted(sort_type, page_no)
    sort_type ||= 'active'
    case sort_type
    when 'active'
      questions = Question.order(updated_at: :desc).page(page_no)
    when 'newest'
      questions = Question.order(created_at: :desc).page(page_no)
    when 'votes'
      questions = Question.order(cached_votes_score: :desc).page(page_no)
    else
      sort_type = 'active'
      questions = Question.order(updated_at: :desc).page(page_no)
    end
    [sort_type, questions]
  end
end
