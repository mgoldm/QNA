# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create :user }
  let(:question) { create :question, user: user }

  subject { described_class }

  permissions :create? do
    it 'authenticated user can add answer' do
      expect(subject).to permit(User.new)
    end
  end

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:answer))
    end

    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:answer))
    end
  end

  permissions :update_best? do
    it 'grants access is user is author' do
      expect(subject).to permit(user, create(:answer, question: question))
    end
  end

  permissions :destroy? do
    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end
  end
end
