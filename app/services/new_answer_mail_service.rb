# frozen_string_literal: true

class NewAnswerMailService
  def send_notification(users, answer)
    users.find_each(batch_size: 500) do |user|
      NotificationMailer.notification(user, answer).deliver_later
    end
  end
end
