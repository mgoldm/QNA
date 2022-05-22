# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerMailService, type: :service do
  let!(:users) { create_list(:user, 3) }
  let(:question){create(:question, users[0])}
  let(:answer){create(:answer, users.first, question: question)}

  it 'sends notification to users' do
    users.each { |user| expect(NotificationMailer).to receive(:notification).with(user).and_call_original }
    subject.send_notification(users, answer)
  end
end

