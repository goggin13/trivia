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

  def self.all_user_stats(round=nil)
    User.all.map do |u|
      if round.present?
        StatsService.user_round_stats(u, round)
      else
        StatsService.user_stats(u)
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

  def self.user_round_stats(user, round)
    _format_result(user, round, _query(user, round))
  end

  def self.user_stats(user)
    user_stat = _format_result(user, nil, _query(user))
    user_stat.rounds_completed = _rounds_completed(user)

    user_stat
  end

  def self._rounds_completed(user)
    sql = <<SQL
    SELECT COUNT(distinct round_id) as count
    FROM questions Q
    LEFT JOIN user_answers A ON
      A.question_id = Q.id
      AND A.user_id = :user_id
    WHERE
      A.id is null
SQL

    query = ActiveRecord::Base.sanitize_sql([sql, :user_id => user.id])
    rounds_remaining = ActiveRecord::Base.connection.execute(query)[0]["count"]

    Round.count - rounds_remaining
  end

  def self._format_result(user, round, result)
    completed = result[0]["completed"] || 0
    remaining = if round.present?
      round.questions.count - completed
    else
      Question.count - completed
    end

    UserStats.new(
      :username => user.username,
      :correct => result[0]["correct"] || 0,
      :completed => completed,
      :duration => result[0]["duration"] || 0,
      :remaining => remaining,
    )
  end

  def self._query(user, round=nil)
    sql = <<SQL
      SELECT
        sum(case when A.id is not null then 1 else 0 end) as completed,
        sum(case when correct then 1 else 0 end) as correct,
        AVG(duration) as duration
      FROM questions Q
      INNER JOIN user_answers A ON
        A.question_id = Q.id
      INNER JOIN options O ON
        A.option_id = O.id
      WHERE user_id = :user_id
SQL

    if round
      sql += " AND round_id = :round_id"
    end

    query = ActiveRecord::Base.sanitize_sql([
      sql,
      :user_id => user.id,
      :round_id => round.try(:id)
    ])

    ActiveRecord::Base.connection.execute(query)
  end
end
