class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def show
    @question = Question.find(params[:id])
    @round = @question.round
    @game = @round.game
    service = StatsService.new(current_user, @game)
    @user_stats = service.user_round_stats(@round)
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
    @game = @round.game
    @next_question = @round.next_question(current_user)
  end
end
