module StaticPagesHelper
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
