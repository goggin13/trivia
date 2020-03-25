class Question < ApplicationRecord
  has_many :options
  validates_presence_of :prompt

  def self.create_from_json(params)
    params = params.symbolize_keys if params.respond_to?(:symbolize_keys)
    question = Question.create!(:prompt => params[:question])

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
    options.where("correct").first!
  end

  def next
    Question
      .where("id > ?", id)
      .order("id asc")
      .first
  end

  def answered?(user)
    UserAnswer.where(:user => user, :question => self).count > 0
  end
end
