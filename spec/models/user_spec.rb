require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'is valid with an email and password' do
    user = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(password: 'password123', password_confirmation: 'password123')
    expect(user).not_to be_valid
  end

  it 'is invalid with a duplicate email' do
    User.create(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    user = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    expect(user).not_to be_valid
  end

  it 'is invalid with a short password' do
    user = User.new(email: 'test@example.com', password: 'short', password_confirmation: 'short')
    expect(user).not_to be_valid
  end
end
