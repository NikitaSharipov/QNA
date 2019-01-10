FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "answer_text_#{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
