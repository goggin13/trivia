game = Game.find_or_create_by!(title: "Simpsons Trivia")
puts "Found game:#{game.id}"
UserAnswer
  .joins(:question)
  .joins(:round)
  .where("rounds.game_id = ?", game.id)
  .destroy_all
game.rounds.each { |round| round.destroy }
puts "destroyed existing rounds"

round = Round.create!(game: game)
puts "starting with round #{round.label}"

File.readlines("simpsons.questions").each do |line|
  parsed = JSON.parse(line)

  if round.questions.count == (Rails.env.production? ? 10 : 3)
    round = Round.create!(game: game)
    puts "Creating new round #{round.label}"
  end

  prompt = parsed["question"]
  question = Question.create!(:prompt => prompt, :round => round)

  Option.create!(:prompt => parsed["answer"], :question => question, :correct => true)


  [parsed["option_1"], parsed["option_2"]].each do |answer|
    Option.create!(:prompt => answer, :question => question, :correct => false)
  end

  puts "#{question.id} : #{question.prompt}"
  question.options.each do |option|
    puts "\t#{option.prompt}"
  end
end

