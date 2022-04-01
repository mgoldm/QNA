# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'best answer' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, best: true) }
  end
end
