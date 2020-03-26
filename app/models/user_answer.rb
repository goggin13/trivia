class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :option
  has_one :round, :through => :question
end
