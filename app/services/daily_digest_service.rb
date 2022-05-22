# frozen_string_literal: true

class DailyDigestService
  def send_digest
    User.find_each(batch_size: 500) do |user|
      Question.find_each(batch_size: 500) do |question|
        questions << question if question.check_date
        DailyDigestMailer.digest(user, questions).deliver_later if questions.present?
      end
    end
  end
end
