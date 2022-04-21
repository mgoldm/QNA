# frozen_string_literal: true

require 'rails_helper'

feature 'User can add vote to answer', "
  user can like answer if it helps him
  author of answer doesnt see form
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_user) { create(:user) }

  describe 'Author' do
    before do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'Author cant vote', js: true do
      expect(page).to_not have_content 'Number'
    end

    scenario 'Author cant vote', js: true do
      expect(page).to have_content 0
    end
  end

  scenario 'try to vote ', js: true do
    sign_in(another_user)

    visit question_path(question)

    select(1, from: 'number')
    click_on 'Save'

    expect(page).to have_content 1

  end
end
