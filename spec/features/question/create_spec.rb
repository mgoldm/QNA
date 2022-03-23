# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  in order to get answer from community
  as an authenticated user
  i'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Authenticated user asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'Authenticated user asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Authenticated user' do
    given(:another_user) do
      create(:user, email: '12345678@mail.ru', password: '123456', password_confirmation: '123456')
    end
    let(:question) { create(:question, user_id: user.id) }

    scenario 'Author try to delete his question' do
      sign_in(user)

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question was deleted successful'
    end

    scenario 'User try to delete answer' do
      sign_in(another_user)

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content "You don't have permission"
    end
  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
