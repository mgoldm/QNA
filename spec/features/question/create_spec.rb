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

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within find('.add-new-file') do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end
      click_on 'Ask'

      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    context "multiply sessions" do
      scenario "question appears on another users page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
        end
        Capybara.using_seshsion('guest') do
          visit questions_path
        end

        Capybara.using_session('user') do
          page.find("add_question_btn".trigger('click'))
          visit questions_path(question)

          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'test test'
          click_on 'Ask'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
