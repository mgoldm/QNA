# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to mu question
  as an question's author
  i'd like to be able to add links
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:url) { 'https://github.com/mgoldm/QNA' }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds link when answer question', js: true do
    fill_in 'Title', with: 'My answer'
    fill_in 'Correct', with: 'My correct'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: url

    click_on 'Answer'

    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'My gist'
    end
  end

  scenario 'Author add link to answer', js: true do
    click_on 'Edit'
    click_on 'add link'

    within find('.answers') do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: url
    end

    click_on 'Create'

    visit question_path(question)

    expect(page).to have_content 'My gist'
  end
end
