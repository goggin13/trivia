# README

users
  id

questions
  text
  answer_id
  round_id

answers
  text
  question_id

user_answers
  question_id
  answer_id
  correct

round
  label

GET /questions/next
{
  "id": 1,
  "text": "what is my favorite color",
  "answers": [
    {"id": 1, "blue"},
    {"id": 2, "red"},
    {"id": 3, "green"},
  ]
}

POST /questions/<question-id>/answer/<option_id>


HOME page

First time: Start Round I
Returning to round: Complete Round I
