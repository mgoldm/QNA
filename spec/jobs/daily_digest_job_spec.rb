# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('DailyDigestService') }

  before do
    allow(DailyDigestService).to recieve(:new).and_return(service)
  end

  it 'calls DailyDigestService' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
