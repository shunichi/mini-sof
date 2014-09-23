class StaticPagesController < ApplicationController
  def home
    @sort_type = params[:sort] || 'active'
    case @sort_type
    when 'active'
      @questions = Question.order(updated_at: :desc).page(params[:page])
    when 'newest'
      @questions = Question.order(created_at: :desc).page(params[:page])
    when 'votes'
      @questions = Question.order(cached_votes_score: :desc).page(params[:page])
    else
      @questions = Question.order(updated_at: :desc).page(params[:page])
    end
  end
end
