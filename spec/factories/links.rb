FactoryBot.define do
  factory :link do
    name { "MyLink" }
    url { "https://www.google.ru" }

    trait :gist do
      url { "https://gist.github.com/NikitaSharipov/3bc4b48e94e824734fd4e1eff6e9fc83" }
    end

  end
end
