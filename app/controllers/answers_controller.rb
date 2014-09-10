class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_users_answer, only: [:update, :destroy]
  before_action :set_answer, only: [:accept, :unaccept]

  def create
    @answer = Answer.new(answer_params)

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @answer.question, notice: 'Answer was successfully created.' }
        format.json { render :show, status: :created, location: @answer.question }
      else
        format.html do
          @question = @answer.question
          render template: 'questions/show'
        end
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update!(answer_params)
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to @answer.question, notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
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

  private
    def set_current_users_answer
      @answer = current_user.answers.find(params[:id])
    end

    def set_answer
      @question = current_user.questions.find(params[:question_id])
      @answer = @question.answers.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :body)
    end
end
