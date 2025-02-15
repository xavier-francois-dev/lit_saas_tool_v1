FactoryBot.define do
  factory :api_token do
    user { nil }
    token { "MyString" }
    last_used_at { "2025-02-14 20:40:52" }
  end
end
