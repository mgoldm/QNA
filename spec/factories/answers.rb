# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    title { 'MyString' }
    correct { 'true' }
    question_id { create(:question).id }
    user_id { create(:user).id }

    trait :invalid do
      title { nil }
      correct { nil }
    end
  end
end
