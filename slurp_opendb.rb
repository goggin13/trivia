require "cgi"

results_to_pull = 50
url = "https://opentdb.com/api.php?amount=#{results_to_pull}&type=multiple&category=9"

results = JSON.parse(`curl -s '#{url}'`.chomp)

round = Round.last!
round_limit = 25
results["results"].each do |result|
  puts result["category"]

  if round.questions.count > round_limit
    round = Round.create!(:label => "Round #{Round.count + 1}")
    puts "Creating new round #{round.label}"
  end

  prompt = CGI.unescapeHTML(result["question"])
  if Question.where(:prompt => prompt).count > 0
    puts "Duplicate, skipping"
    next
  end

  question = Question.create!(:prompt => prompt, :round => round)

  Option.create!(
    :prompt => CGI.unescapeHTML(result["correct_answer"]),
    :question => question,
    :correct => true,
  )

  result["incorrect_answers"].each do |answer|
    Option.create!(
      :prompt => CGI.unescapeHTML(answer),
      :question => question,
      :correct => false,
    )
  end

  puts "#{question.id} : #{question.prompt}"
  question.options.each do |option|
    puts "\t#{option.prompt}"
  end
end
