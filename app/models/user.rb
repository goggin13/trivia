class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :authentication_keys => [:username]

  validates_presence_of :username

  has_many :user_answers

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def next_round(game)
    answered_ids = user_answers.map(&:question_id)
    answered_ids = -1 if answered_ids.length == 0
    question = Question
      .joins(:round)
      .where("rounds.game_id = ?", game.id)
      .where("questions.id not in (?)", answered_ids)
      .order("round_id ASC")
      .first

    question.present? ? question.round : nil
  end

  def average_duration
    user_answers.inject(0) { |sum, el| sum + el.duration }.to_f / user_answers.size
  end
end
