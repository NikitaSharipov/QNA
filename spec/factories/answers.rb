FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "answer_text_#{n}" }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain') }
    end
  end
end
