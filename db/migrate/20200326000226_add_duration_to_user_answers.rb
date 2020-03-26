class AddDurationToUserAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :user_answers, :duration, :float, :default => 0.0
  end
end
