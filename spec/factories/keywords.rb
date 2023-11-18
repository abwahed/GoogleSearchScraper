# frozen_string_literal: true

FactoryBot.define do
  factory :keyword do
    user
    sequence(:name) { |n| "MyString-#{n}" }
  end
end
