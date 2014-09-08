class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy]

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = current_user.answers.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :body)
    end
end
