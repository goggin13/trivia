class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def create
    @question = Question.create_from_json(params)
  end

  def show
    @question = Question.find(params[:id])
    @correct, @total = current_user.score
  end

  def answer
    @question = Question.find(params[:question_id])
    @option = Option.find(params[:answer_id])
    UserAnswer.create!(
      :question => @question,
      :option => @option,
      :user => current_user,
      :duration => params[:duration]
    )
  end
end
