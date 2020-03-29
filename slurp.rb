
round = nil
if Round.count == 0
  round = Round.create!(:label => "Round #{Round.count + 1}")
end

JSON.parse(File.read("json_questions.json").chomp).each do |question|
  puts question
  if round.questions.count > Round.questions_per_round
    round = Round.create!(:label => "Round #{Round.count + 1}")
    puts "Creating new round #{round.label}"
  end
  puts Question.create_from_json(question, round)
end
