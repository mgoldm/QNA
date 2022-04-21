# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
in order to correct mistakes
an an author of answer
i'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user, best: false) }
  let!(:another_user) { create(:user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Edit'
  end

  scenario 'tries to edit other answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Edit'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edit his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Correct', with: 'edited title'
        click_on 'Create'

        visit question_path(question)

        expect(page).to_not have_content answer.correct
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Correct', with: ''
        click_on 'Create'
      end
      expect(page).to have_content "Correct can't be blank"
    end

    scenario 'edit best answer' do
      within '.select-best' do
        click_on 'Select best answer'
        click_on 'Select best answer'
      end

      page.check('Select new best')
    end

    scenario 'Author add file to answer', js: true do
      click_on 'Edit'

      within find('.answers') do
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Create'

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'Author delete file' do
      click_on 'Edit'

      within find('.answer-files') do
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Create'

      visit question_path(question)

      click_on 'Delete file'

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end
end
