FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "question_title#{n}" }
    sequence(:body) { |n| "question_text#{n}" }

    trait :invalid do
      title { nil }
    end
  end
end
