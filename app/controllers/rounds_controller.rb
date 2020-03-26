class RoundsController < ApplicationController
  def show
    @round = Round.find(params[:id])

    @stats = User.all.map { |u| StatsService.user_round_stats(u, @round) }
  end
end
