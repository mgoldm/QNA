# frozen_string_literal: true

require 'rails_helper'

feature 'User can add reward to question', "
  In order to provide additional info to mu question
  as an question's author
  User can get reward for best answer
" do
  given!(:user) { create(:user) }

  describe 'Reward functions'

  scenario 'Create question with file' do
    sign_in(user)

    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within find('.new-reward') do
      fill_in 'Reward name', with: '123'
      attach_file 'Image', "#{Rails.root}/spec/fixtures/files/i.jpeg"
    end

    click_on 'Ask'
  end

  scenario 'User get reward for best questions', js: true do
    sign_in(user)

    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within find('.new-reward') do
      fill_in 'Reward name', with: '123'
      attach_file 'Image', "#{Rails.root}/spec/fixtures/files/i.jpeg"
    end

    click_on 'Ask'
    within '.new-answer' do
      fill_in 'Title', with: 'Test answer'
      fill_in 'Correct', with: 'text text text'
      click_on 'Answer'
    end

    visit question_path(Question.last)

    within '.select-best' do
      click_on 'Select best answer'
      click_on 'Select best answer'
    end

    page.check('Select new best')

    click_on 'Select'

    visit rewards_path

    expect(page).to have_content '123'
  end
end
