# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerMailService.new.send_notification(answer.question.subs, answer)
  end
end
