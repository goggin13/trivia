class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def create
    @question = Question.create_from_json(params)
  end

  def show
    @question = Question.find(params[:id])
    @round = @question.round
    @user_stats = StatsService.user_round_stats(current_user, @round)
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
    @round = @question.round
    @next_question = @round.next_question(current_user)
  end
end
