class StatsService
  class UserStats
    attr_accessor :correct, :completed, :duration, :email, :remaining

    def initialize(correct:, completed:, duration:, email:, remaining:)
      @correct = correct
      @completed = completed
      @duration = duration
      @email = email
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

  def self.user_round_stats(user, round)
    _format_result(user, round, _query(user, round))
  end

  def self.user_stats(user)
    _format_result(user, nil, _query(user))
  end

  def self._format_result(user, round, result)
    completed = result[0]["completed"] || 0
    remaining = if round.present?
      round.questions.count - completed
    else
      Question.count - completed
    end

    UserStats.new(
      :email => user.email,
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
