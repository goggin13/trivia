class Round < ApplicationRecord
  has_many :questions

  def answered_questions(user)
    return @_answered_questions if defined?(@_answered_questions)
    @_answered_questions = UserAnswer.where(
      :user_id => user.id,
      :question_id => questions.map(&:id)
    ).order("question_id ASC")
  end

  def next_question(user)
    question_ids_left = questions.map(&:id) - answered_questions(user).map(&:question_id)

    if question_ids_left.length > 0
      Question.find(question_ids_left[0])
    end
  end
end
