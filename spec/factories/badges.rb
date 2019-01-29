FactoryBot.define do
  factory :badge do
    sequence(:title) { |n| "badge_title#{n}" }
  end
end
