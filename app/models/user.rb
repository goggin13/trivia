class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :user_answers

  def score(round)
    answered_in_round = user_answers.joins(:round).where("rounds.id = ?", round.id)
    [
      answered_in_round.joins(:option).where("correct").count,
      answered_in_round.count,
    ]
  end

  def all_time_score
    [
      user_answers.joins(:option).where("correct").count,
      user_answers.count,
    ]
  end

  def next_round
    answered_ids = user_answers.map(&:question_id)
    answered_ids = -1 if answered_ids.length == 0
    question = Question
      .where("id not in (?)", answered_ids)
      .order("round_id ASC")
      .first

    question.present? ? question.round : nil
  end

  def average_duration
    user_answers.inject(0) { |sum, el| sum + el.duration }.to_f / user_answers.size
  end
end
