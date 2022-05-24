# frozen_string_literal: true

class DailyDigestService
  def send_digest
    questions = Question.check_date
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions).deliver_later if questions.present?
    end
  end
end
