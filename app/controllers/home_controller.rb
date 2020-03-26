class HomeController < ApplicationController
  def home
    if signed_in?
      @next_round = current_user.next_round
      if @next_round
        @next_question = @next_round.next_question(current_user)
      end

      @stats = StatsService.all_user_stats
    end
  end
end
