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
    end

    scenario 'Authenticated user answer', js: true do
      fill_in 'Title', with: 'Test answer'
      fill_in 'Correct', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_content 'Test answer'
      expect(page).to have_content 'text text text'
    end

    scenario 'Authenticated user answer for a question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content 'blank'
    end
  end

  scenario 'Unauthenticated user tries to answer on question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
