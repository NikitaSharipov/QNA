FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "comment_text_#{n}" }
  end
end
