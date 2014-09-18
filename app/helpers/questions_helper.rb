module QuestionsHelper
  def accepted_answer_class(question, answer)
    link_class(question) + check_mark_class(question, answer)
  end

  def vote_arrow_class(question, value)
    if user_signed_in?
      vote_arrow_link_class(value) +
        (question.vote_value_by(current_user) == value ? ' question-voted' : '')
    else
      'question-vote-disabled'
    end
  end


  private
    def link_class(question)
      (current_user == question.user) ? 'accept-link ' : ''
    end

    def check_mark_class(question, answer)
      if question.accepted_answer == answer
        'accepted-on'
      elsif current_user == question.user
        'accepted-off'
      else
        'accepted-none'
      end
    end

    def vote_arrow_link_class(value)
      value == 1 ? 'question-upvote' : 'question-downvote'
    end
end
