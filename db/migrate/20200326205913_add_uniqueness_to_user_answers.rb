class AddUniquenessToUserAnswers < ActiveRecord::Migration[6.0]
  def change
    add_index :user_answers, [:user_id, :question_id], :unique => true
  end
end
