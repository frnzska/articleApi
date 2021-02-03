FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "login #{n}" }
    sequence(:name) { |n| "name #{n}" }
    sequence(:url) { |n| "url-#{n}" }
    sequence(:avatar_url) { |n| "avatar #{n}" }
    sequence(:provider) { |_n| 'github' }
  end
end
