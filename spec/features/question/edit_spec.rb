# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
in order to correct mistakes
an an author of answer
i'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: '345', user: user) }
  let!(:another_user) { create(:user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Edit question'
  end

  scenario 'tries to edit other answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Edit question'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit question'
      click_on 'Edit question'
    end

    scenario 'edit his answer' do
      find('#question_title').fill_in(with: '123')

      within find('.edit-question') do
        click_on 'Answer'
      end

      expect(page).to_not have_content question.title
      expect(page).to have_content '123'
    end

    scenario 'Author add file to question', js: true do
      within find('.add-files') do
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      end

      within find('.edit-question') do
        click_on 'Answer'
      end

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'Author delete file' do
      within find('.add-files') do
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      end

      within find('.edit-question') do
        click_on 'Answer'
      end

      within find('.delete-question-file') do
        click_on 'Delete file'
      end

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end
end
