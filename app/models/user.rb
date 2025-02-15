class User < ApplicationRecord
  has_secure_password

  belongs_to :parish
  has_many :api_tokens, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  def password_required?
    roles.none? { |role| role.name == "api_user" } || password.present?
  end
end
