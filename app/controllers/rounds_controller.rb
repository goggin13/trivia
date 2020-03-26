class RoundsController < ApplicationController
  def show
    @round = Round.find(params[:id])

    @stats = StatsService.all_user_stats(@round)
  end
end
