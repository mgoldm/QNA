require 'rails_helper'

feature 'Author can delete his answer', "
  Other users can't delete answers
" do
  let!(:user) { create(:user) }

  describe 'Users try to delete' do
    let!(:question) { create(:question, user_id: user.id) }
    let(:another_user) { create(:user) }


    let!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

    scenario 'Author try to delete his question' do

      sign_in(user)

      visit question_path(question)

      click_on 'Delete answer'

      expect(page).to have_content 'Answer was deleted successful'
    end

    scenario 'User try to delete answer' do
      sign_in(another_user)

      visit question_path(question)

      expect(page).to_not have_content "Delete answer"
    end

    scenario 'Unauthenticated user try to delete question' do
      visit question_path(question)

      expect(page).to_not have_content "Delete answer"
    end
  end
end