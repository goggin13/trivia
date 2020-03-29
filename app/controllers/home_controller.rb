class HomeController < ApplicationController
  def home
    if signed_in?
      @stats = StatsService.all_user_stats
      @best_round = StatsService.best_round
    end
  end
end
