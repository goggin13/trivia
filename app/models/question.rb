class Question < ApplicationRecord
  has_many :options, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  belongs_to :round
  validates_presence_of :prompt

  def self.create_from_json(params, round)
    params = params.symbolize_keys if params.respond_to?(:symbolize_keys)
    question = Question.create!(
      :prompt => params[:question],
      :round => round,
    )

    ["A", "B", "C", "D"].each do |letter|
      Option.create!(
        :prompt => params[letter.to_sym],
        :question => question,
        :correct => (params[:answer] == letter)
      )
    end

    question
  end

  def answer
    options.correct.first!
  end

  def answered?(user)
    UserAnswer.where(:user => user, :question => self).count > 0
  end
end
