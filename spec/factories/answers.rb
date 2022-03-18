# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    title { 'MyString' }
    correct { true }

    trait :invalid do
      title { nil }
      correct { nil }
    end
  end
end
