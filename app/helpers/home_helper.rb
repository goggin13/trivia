module HomeHelper
  def next_round_link(user)
    next_round = current_user.next_round(@game)
    if next_round
      next_question = next_round.next_question(current_user)
      link_to "Play #{next_round.label} of #{@game.title}", question_path(next_question), data: { turbolinks: false }
    else
      "You have completed all of the rounds."
    end
  end
end
