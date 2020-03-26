def sign_in(user)
  visit "/users/sign_in"
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
  expect(page).to have_content("Signed in successfully.")
end

def answer_correct(user, question)
  FactoryBot.create(
    :user_answer,
    user: user,
    question: question,
    option: question.answer
  )
end

def answer_incorrect(user, question)
  FactoryBot.create(
    :user_answer,
    user: user,
    question: question,
    option: question.options.incorrect.first!
  )
end
