# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  in order to get answer from community
  as an authenticated user
  i'd like to be able to ask the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  describe 'Authenticated user' do
    context 'multiply sessions' do
      scenario 'Comment appears on another users page', js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
        end
        Capybara.using_session('guest') do
          visit questions_path
        end

        Capybara.using_session('user') do
          fill_in 'Comment', with: 'Test comment'

          within '.answers-comments' do
            click_on 'Save'
          end
        end

        Capybara.using_session('guest') do
          visit questions_path
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end
end
