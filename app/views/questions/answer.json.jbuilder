json.correct @option.correct
json.correct_option @question.answer, :id
if @next_question.present?
  json.redirect question_path(@next_question)
else
  json.redirect round_path(@round)
end
