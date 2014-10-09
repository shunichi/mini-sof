class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :upvote, :downvote]
  before_action :set_current_users_question, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:show, :upvote, :downvote]
  before_action :set_answer, only: [:show]

  def index
    @sort_type, @questions = Question.sorted(params[:sort], params[:page])
    @questions_answer_counts = Answer.where(question_id: @questions.pluck(:id)).group(:question_id).count
    @questions = @questions.includes(:user)
  end

  def show

  end

  def new
    @question = current_user.questions.build
  end

  def edit
  end

  def create
    @question = current_user.questions.create(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    def set_current_users_question
      @question = current_user.questions.find(params[:id])
    end

    def set_answer
      @answer = @question.answers.build(user: current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
