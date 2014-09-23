class StaticPagesController < ApplicationController
  def home
    @sort_type = params[:sort] || 'active'
    case @sort_type
    when 'active'
      @questions = Question.order(updated_at: :desc)
    when 'newest'
      @questions = Question.order(created_at: :desc)
    when 'votes'
      @questions = Question.order(cached_votes_score: :desc)
    else
      @questions = Question.order(updated_at: :desc)
    end
  end
end
