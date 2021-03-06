class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_users_answer, only: [:update, :destroy]
  before_action :set_answer_for_current_users_question, only: [:accept, :unaccept]
  before_action :set_any_answer, only: [:upvote, :downvote]

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to @answer.question, notice: 'Answer was successfully created.'
    else
      @question = @answer.question
      render template: 'questions/show'
    end
  end

  def update
    @answer.update!(answer_params)
    render json: { answer: { id: @answer.id, body: @answer.body } }
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: 'Answer was successfully destroyed.'
  end

  def accept
    @question.accepted_answer = @answer
    @question.save!
    render json: { answer: { id: @answer.id } }
  end

  def unaccept
    if @question.accepted_answer == @answer
      @question.accepted_answer = nil
      @question.save!
      render json: { answer: { id: nil } }
    else
      head :bad_request
    end
  end

  def upvote
    @answer.toggle_vote_up current_user
    render json: { votes_score: @answer.votes_score, vote_value: @answer.vote_value_by(current_user) }
  end

  def downvote
    @answer.toggle_vote_down current_user
    render json: { votes_score: @answer.votes_score, vote_value: @answer.vote_value_by(current_user) }
  end

  private
    def set_current_users_answer
      @answer = current_user.answers.find(params[:id])
    end

    def set_answer_for_current_users_question
      @question = current_user.questions.find(params[:question_id])
      @answer = @question.answers.find(params[:id])
    end

    def set_any_answer
      @question = Question.find(params[:question_id])
      @answer = @question.answers.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :body)
    end
end
