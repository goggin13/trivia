# README

users
  id

questions
  text
  answer_id

answers
  text
  question_id

user_answers
  question_id
  answer_id
  correct


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

POST /user_answers/<question-id>/<answer_id>
