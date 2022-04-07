# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  before do
    sign_in(user)
    question.files.attach(io: file_fixture('rails_helper.rb').open, filename: 'rails_helper.rb')
  end

  describe 'DELETE #destroy' do
    context 'Author delete' do
      it 'delete file' do
        expect do
          delete :destroy, params: { id: question.files.last }, format: :js
        end.to change(question.files, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: question.files.last, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'user DELETE' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'delete file' do
        expect do
          delete :destroy, params: { id: question.files.last, format: :js }
        end.to_not change(question.files, :count)
      end

      it 'redirect to show question' do
        delete :destroy, params: { id: question.files.last, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
