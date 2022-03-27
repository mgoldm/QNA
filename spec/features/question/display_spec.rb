# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated can see question on show and index', "
 Unauthenticated can see question on index and show
" do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'Authenticated' do
    before do
      sign_in(user)
    end

    scenario 'Authenticated user can see questions on index' do
      expect(page).to have_content question.title
    end

    scenario 'Authenticated user can see question on show' do
      click_on 'show'

      expect(page).to have_content question.title
    end
  end

  describe 'Unauthenticated' do
    before { visit questions_path }

    scenario 'Unauthenticated user can see questions on index' do
      expect(page).to have_content question.title
    end

    scenario 'Unauthenticated user can see question on show' do
      click_on 'show'

      expect(page).to have_content question.title
    end
  end
end
