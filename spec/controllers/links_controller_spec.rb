# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  before do
    sign_in(user)
  end

  describe 'DELETE #destroy' do
    context 'Author delete' do
      it 'delete link' do
        expect do
          delete :destroy, params: { id: link }, format: :js
        end.to change(question.links, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: question.links.last, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'user DELETE' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'delete link' do
        expect do
          delete :destroy, params: { id: question.links.last, format: :js }
        end.to_not change(question.links, :count)
      end

      it 'redirect to show question' do
        delete :destroy, params: { id: question.links.last, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
