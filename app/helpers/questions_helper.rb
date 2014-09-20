module QuestionsHelper
  def accepted_answer_class(question, answer)
    link_class(question) + check_mark_class(question, answer)
  end

  def vote_arrow_class(question, value)
    classes = ['vote-arrow']
    if user_signed_in?
      classes.push(value == 1 ? 'upvote' : 'downvote')
      classes.push('voted') if question.vote_value_by(current_user) == value
    else
      classes.push('disabled')
    end
    classes.join(' ')
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
end
