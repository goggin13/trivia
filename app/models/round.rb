class Round < ApplicationRecord
  has_many :questions, dependent: :destroy
  belongs_to :game
	validates_presence_of :game_id
  before_save :set_label

  def self.questions_per_round
    if Rails.env.production?
      20
    else
      5
    end
  end

  def answered_questions(user)
    return @_answered_questions if defined?(@_answered_questions)
    @_answered_questions = UserAnswer.where(
      :user_id => user.id,
      :question_id => questions.map(&:id)
    )
  end

  def next_question(user)
    question_ids_left = questions.map(&:id) - answered_questions(user).map(&:question_id)

    if question_ids_left.length > 0
      Question.find(question_ids_left[0])
    end
  end

  private

  def set_label
    if self.label.nil?
      self.label = "Round #{game.rounds.count + 1}"
    end
  end
end
