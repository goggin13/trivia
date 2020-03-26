def sign_in(user)
  visit "/users/sign_in"
  fill_in 'Email', with: user.email
  # fill_in 'Password', with: user.password
  click_button 'Sign in'
  expect(page).to have_content("Signed in successfully.")
end

def answer_correct(user, question, options={})
  answer(user, question, options.merge(
    option: question.answer
  ))
end

def answer_incorrect(user, question, options={})
  answer(user, question, options.merge(
    option: question.options.incorrect.first!
  ))
end

def answer(user, question, params)
  options = default = {
    user: user,
    question: question,
    option: question.options.incorrect.first!
  }.merge(params)

  FactoryBot.create(:user_answer, options)
end
