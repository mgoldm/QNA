# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?' do
    let!(:user) { create(:user) }

    it 'true for author' do
      check = create(:question, user: user)

      expect(user).to be_author_of(check)
    end

    it 'false for other users' do
      check = create(:question)
      expect(user).to_not be_author_of(check)
    end
  end
end
