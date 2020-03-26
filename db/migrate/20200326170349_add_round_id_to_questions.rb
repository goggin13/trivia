class AddRoundIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :round_id, :integer, null: true, foreign_key: false

    round_number = 0
    round = nil
    UserAnswer.delete_all
    Round.delete_all
    Question.all.each_with_index do |question, i|
      if i % 5 == 0
        round_number += 1
        round = Round.create!(:label => "Round #{round_number}")
      end
      puts "assigning q:#{question.id} to #{round.label}"
      question.update_attributes!(:round => round)
    end

    change_column :questions, :round_id, :integer, null: false, foreign_key: true
  end
end
