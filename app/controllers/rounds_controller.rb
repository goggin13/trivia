class RoundsController < ApplicationController
  def show
    @round = Round.find(params[:id])
    @game = @round.game

    @stats = StatsService.all_user_stats(@game, @round)
  end
end
