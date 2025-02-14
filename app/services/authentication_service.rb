class AuthenticationService
  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user if user&.authenticate(password)
  end
end
