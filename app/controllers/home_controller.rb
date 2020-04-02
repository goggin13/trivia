class HomeController < ApplicationController
  before_action :set_game

  def home
    if signed_in?
      service = StatsService.new(@current_user, @game)
      @stats = StatsService.all_user_stats(@game)
      @best_round = service.best_round
    end
  end

  private

  def set_game
    if params[:game_id]
      @game = Game.find(params[:game_id])
    else
      @game = Game.first!
    end
  end
end
