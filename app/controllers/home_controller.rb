class HomeController < ApplicationController
  def home
    if signed_in?
      @stats = StatsService.all_user_stats
    end
  end
end
