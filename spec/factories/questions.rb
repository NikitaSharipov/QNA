FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "question_title#{n}" }
    sequence(:body) { |n| "question_text#{n}" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain') }
    end
  end
end
