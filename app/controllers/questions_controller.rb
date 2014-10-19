class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :upvote, :downvote]
  before_action :set_current_users_question, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:show, :upvote, :downvote]

  def index
    @sort_type = params[:sort] || 'active'
    @questions = Question.sorted(@sort_type).page(params[:page]).includes(:user)
  end

  def show
      @answer = @question.answers.build(user: current_user)
  end

  def new
    @question = current_user.questions.build
  end

  def edit
  end

  def create
    @question = current_user.questions.create(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to root_url, notice: 'Question was successfully destroyed.'
  end

  def upvote
    @question.toggle_vote_up current_user
    render json: { votes_score: @question.votes_score, vote_value: @question.vote_value_by(current_user) }
  end

  def downvote
    @question.toggle_vote_down current_user
    render json: { votes_score: @question.votes_score, vote_value: @question.vote_value_by(current_user) }
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def set_current_users_question
      @question = current_user.questions.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end
