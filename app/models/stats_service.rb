class StatsService
  class UserStats
    attr_accessor(
      :correct,
      :completed,
      :duration,
      :username,
      :remaining,
      :rank,
      :rounds_completed,
    )

    def initialize(correct:, completed:, duration:, username:, remaining:)
      @correct = correct
      @completed = completed
      @duration = duration
      @username = username
      @remaining = remaining
    end

    def percentage
      if @completed > 0
        @correct / @completed.to_f * 100.0
      else
        0
      end
    end

    def total
      completed + remaining
    end
  end

  def initialize(user, game)
    @user = user
    @game = game
  end

  def self.all_user_stats(game, round=nil)
    User.all.map do |user|
      if round.present?
        StatsService.new(user, game).user_round_stats(round)
      else
        StatsService.new(user, game).user_stats
      end
    end.sort do |a, b|
      if a.percentage > b.percentage
        -1
      elsif b.percentage > a.percentage
        1
      else
        a.duration <=> b.duration
      end
    end.each_with_index do |stat, index|
      stat.rank = index + 1
    end.reject do |stat|
      stat.completed == 0
    end
  end

  def user_round_stats(round)
    _format_result(round, _query(round))
  end

  def user_stats
    user_stat = _format_result(nil, _query)
    user_stat.rounds_completed = _rounds_completed

    user_stat
  end

  def _rounds_completed
    sql = <<SQL
    SELECT COUNT(distinct round_id) as count
    FROM questions Q
    INNER JOIN rounds R ON
      Q.round_id = R.id
    LEFT JOIN user_answers A ON
      A.question_id = Q.id
      AND A.user_id = :user_id
    WHERE
      A.id is null
      AND game_id = :game_id
SQL

    query = ActiveRecord::Base.sanitize_sql([
      sql,
      :game_id => @game.id,
      :user_id => @user.id
    ])
    rounds_remaining = ActiveRecord::Base.connection.execute(query)[0]["count"]

    @game.rounds.count - rounds_remaining
  end

  def _format_result(round, result)
    completed = result[0]["completed"] || 0
    remaining = if round.present?
      round.questions.count - completed
    else
      Question.joins(:round).where("rounds.game_id" => @game.id).count - completed
    end

    UserStats.new(
      :username => @user.username,
      :correct => result[0]["correct"] || 0,
      :completed => completed,
      :duration => result[0]["duration"] || 0,
      :remaining => remaining,
    )
  end

  def _query(round=nil)
    sql = <<SQL
      SELECT
        sum(case when A.id is not null then 1 else 0 end) as completed,
        sum(case when correct then 1 else 0 end) as correct,
        AVG(duration) as duration
      FROM questions Q
      INNER JOIN rounds R ON
        Q.round_id = R.id
      INNER JOIN user_answers A ON
        A.question_id = Q.id
      INNER JOIN options O ON
        A.option_id = O.id
      WHERE
        user_id = :user_id
        AND game_id = :game_id
SQL

    if round
      sql += " AND round_id = :round_id"
    end

    query = ActiveRecord::Base.sanitize_sql([
      sql,
      :user_id => @user.id,
      :game_id => @game.id,
      :round_id => round.try(:id)
    ])

    ActiveRecord::Base.connection.execute(query)
  end
end
