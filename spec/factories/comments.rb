# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    comment { 'MyString' }
    user
  end
end
