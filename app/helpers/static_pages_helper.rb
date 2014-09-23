module StaticPagesHelper
  def tab_class(sort_type, current_sort_type)
    if sort_type == current_sort_type
      'active'
    else
      ''
    end
  end

  def answer_stats_class(question)
    if question.answers.size == 0
      "unanswerd"
    elsif !question.accepted_answer.nil?
      "answer-accepted"
    else
      "answered"
    end
  end
end
