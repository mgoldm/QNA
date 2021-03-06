# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question) }
  it 'calls ReputationJob' do
    expect(ReputationJob).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
