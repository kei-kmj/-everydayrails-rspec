# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name { 'Alice' }
    last_name { 'Summer' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }

  end
end