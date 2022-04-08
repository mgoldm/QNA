# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  describe 'gist?' do
    let(:question) { create(:question) }
    let(:link) do
      create(:link, linkable: question, url: 'https://gist.github.com/mgoldm/1d351e0c4bd5185c51b4e30b17d4369f')
    end
    let(:another_link) { create(:link, linkable: question, url: 'https://github.com/mgoldm/QNA') }

    it 'true for gist' do
      expect(link).to be_gist
    end

    it 'false for other links' do
      expect(another_link).to_not be_gist
    end
  end
end
