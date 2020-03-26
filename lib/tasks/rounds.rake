namespace :rounds do
  desc "Regenerate all rounds"
  task :generate, [:round_size] => [:environment] do |task, args|
    round_size = args[:round_size].to_i
    round_number = 0
    round = nil
    UserAnswer.delete_all
    Round.delete_all
    Question.all.each_with_index do |question, i|
      if i % round_size == 0
        round_number += 1
        round = Round.create!(:label => "Round #{round_number}")
      end
      puts "assigning q:#{question.id} to #{round.label}"
      question.update_attributes!(:round => round)
    end
  end
end
