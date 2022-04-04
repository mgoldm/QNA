# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete his answer', "
  Other users can't delete answers
" do
  let!(:user) { create(:user) }

  describe 'Users try to delete', js: true do
    let!(:question) { create(:question, user: user) }
    let(:another_user) { create(:user) }

    let!(:answer) { create(:answer, title: '123', question: question, user: user) }

    scenario 'Author try to delete his question' do
      sign_in(user)

      visit question_path(question)

      expect(page).to have_content answer.title

      click_on 'Delete answer'

      expect(page).to_not have_content answer.title
    end

    scenario 'User try to delete answer' do
      sign_in(another_user)

      visit question_path(question)

      expect(page).to_not have_content 'Delete answer'
    end

    scenario 'Unauthenticated user try to delete question' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete answer'
    end
  end
end
