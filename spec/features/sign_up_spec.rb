# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
" do
  given(:user) { create(:user) }

  describe 'Registration' do
    background do
      visit question_path(create(:question))

      click_on 'Answer'
      click_on 'Sign up'
    end

    scenario 'User try to register' do
      fill_in 'Email', with: 'test@mail.ru'
      fill_in 'Password', with: 'texttexttext'
      fill_in 'Password confirmation', with: 'texttexttext'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'User input invalid values' do
      click_on 'Sign up'

      expect(page).to have_content 'errors prohibited this user from being saved:'
    end
  end
end
