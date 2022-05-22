# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notification(user, answer)
    @greeting = 'Hi'
    mail to: user.email, subject: "Someone add '#{answer.title}' to your question #{answer.question.title}"
  end
end
