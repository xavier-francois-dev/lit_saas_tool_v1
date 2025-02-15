FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    parish { create(:parish) }
    password { Faker::Internet.password }
    password_confirmation { password }

    after(:create) do |user, evaluator|
      user.roles << create(:role, name: 'user')
    end

    trait :api_user do
      after(:create) do |user, evaluator|
        user.roles << create(:role, name: "api_user")
      end
    end
  end
end
