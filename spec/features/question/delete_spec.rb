# frozen_string_literal: true

require 'rails_helper'

feature 'Author can celete question', "
 Another user can't delete
" do
  let!(:user) { create(:user) }
  describe 'Authenticated user' do
    let!(:another_user) { create(:user) }

    let!(:question) { create(:question, user_id: user.id) }

    scenario 'Author try to delete his question' do
      sign_in(user)

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question was deleted successful'
    end

    scenario 'User try to delete answer' do
      sign_in(another_user)

      visit questions_path(question)

      expect(page).to_not have_content 'Delete'
    end

    scenario 'Unauthenticated user try to delete question' do
      visit questions_path(question)

      expect(page).to_not have_content 'Delete'
    end
  end
end
