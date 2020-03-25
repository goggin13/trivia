class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :user_answers
  has_many :correct_user_answers

  def score
    [
      user_answers.joins(:option).where("correct").count,
      user_answers.count,
    ]
  end

  def next_question
    answered_ids = user_answers.map(&:question_id)
    if answered_ids.length == 0
      Question.first!
    else
      Question
        .where("id not in (?)", answered_ids)
        .order("id ASC")
        .first
    end
  end
end
