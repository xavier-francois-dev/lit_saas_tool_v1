require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory for regular users' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'has a valid factory for API users' do
    expect(FactoryBot.build(:user, :api_user)).to be_valid
  end

  it 'is valid with an email and password for regular users' do
    user = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123', parish: create(:parish))
    user.roles << create(:role, name: 'regular_user')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(password: 'password123', password_confirmation: 'password123', parish: create(:parish))
    user.roles << create(:role, name: 'regular_user')
    expect(user).not_to be_valid
  end

  it 'is invalid with a duplicate email' do
    User.create(email: 'test@example.com', password: 'password123', password_confirmation: 'password123', parish: create(:parish))
    user = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123', parish: create(:parish))
    user.roles << create(:role, name: 'regular_user')
    expect(user).not_to be_valid
  end

  it 'is invalid with a short password for regular users' do
    user = User.new(email: 'test@example.com', password: 'short', password_confirmation: 'short', parish: create(:parish))
    user.roles << create(:role, name: 'regular_user')
    expect(user).not_to be_valid
  end

  it 'allows API users to have a password' do
    user = User.new(email: 'api_user@example.com', password: 'password123', password_confirmation: 'password123', parish: create(:parish))
    user.roles << create(:role, name: 'api_user')
    expect(user).to be_valid
  end
end
