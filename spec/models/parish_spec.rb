require 'rails_helper'

RSpec.describe Parish, type: :model do
  # Test for valid factory
  it 'has a valid factory' do
    expect(FactoryBot.build(:parish)).to be_valid
  end

  # Test for presence of name
  it 'is valid with a name' do
    parish = Parish.new(name: 'St. John Parish')
    expect(parish).to be_valid
  end

  it 'is invalid without a name' do
    parish = Parish.new(name: nil)
    expect(parish).not_to be_valid
    expect(parish.errors[:name]).to include("can't be blank")
  end

  # Test for association with users
  it 'has many users' do
    parish = create(:parish)
    user1 = create(:user, parish: parish)
    user2 = create(:user, parish: parish)
    expect(parish.users).to include(user1, user2)
  end

  # Test for association with api_tokens through users
  it 'has many api_tokens through users' do
    parish = create(:parish)
    user = create(:user, parish: parish)
    api_token = create(:api_token, user: user)
    expect(parish.users.first.api_tokens).to include(api_token)
  end

  it 'destroys associated users and their api_tokens when destroyed' do
    parish = create(:parish)
    user = create(:user, parish: parish)
    api_token = create(:api_token, user: user)

    expect { parish.destroy }.to change(User, :count).by(-1)
    expect(ApiToken.where(user_id: user.id)).not_to exist
  end
end
