# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'https://github.com/mgoldm/QNA' }
  end
end
