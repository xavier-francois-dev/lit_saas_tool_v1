class ApiTokenService
  def self.generate_token(user)
    ApiToken.create(user: user)
  end

  def self.validate_token(token)
    ApiToken.find_by(token: token)
  end

  def self.revoke_token(token)
    api_token = ApiToken.find_by(token: token)
    if api_token.nil?
      raise ActiveRecord::RecordNotFound, "Token not found"
    else
      api_token.destroy
    end
  end

  def self.revoke_tokens_for_user(user)
    user.api_tokens.destroy_all
  end

  def self.revoke_tokens_for_parish(parish)
    parish.api_tokens.destroy_all
  end
end
