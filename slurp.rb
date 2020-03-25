JSON.parse(File.read("json_questions.json").chomp).each do |question|
  puts question
  puts Question.create_from_json(question)
end
