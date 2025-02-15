class JwtService
  SECRET_KEY = Rails.application.credentials.jwt_secret_key

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY).first
  rescue JWT::DecodeError
    nil
  end
end
