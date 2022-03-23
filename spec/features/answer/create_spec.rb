# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  in order to get answer from community
  as an authenticated user
  i'd like to be able to answer the question
" do
  given(:user) { create(:user) }

  let(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'New answer'
    end

    scenario 'Authenticated user answer' do
      fill_in 'Title', with: 'Test answer'
      fill_in 'Correct', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content 'Test answer'
      expect(page).to have_content 'text text text'
    end

    scenario 'Authenticated user answer for a question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Authenticated user' do
    given(:another_user) { create(:user, email: '12345678@mail.ru', password: '123456', password_confirmation: '123456') }
    given(:user) { create(:user) }
    let(:answer) { create(:answer, user_id: user.id) }

    scenario 'Author try to delete his question' do
      sign_in(user)

      visit answer_path(answer)
      click_on 'Delete'

      expect(page).to have_content 'Answer was deleted successful'
    end

    scenario 'User try to delete answer' do
      sign_in(another_user)

      visit answer_path(answer)
      click_on 'Delete'

      expect(page).to have_content "You don't have permission"
    end
  end

  scenario 'Unauthenticated user tries to ask question' do
    visit question_path(question)
    click_on 'New answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
