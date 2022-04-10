require_relative "../../lib/request_token"

class AuthenticateRequest
  include Dry::Monads[:result]

  def self.call(token)
    new(token).call
  end

  def initialize(token)
    @token = token
  end

  def call
    token_data = RequestToken.decode(token)

    Success(User.find_by(id: token_data[:user_id]))
  rescue JWT::DecodeError
    Failure()
  end

  private

  attr_reader :token
  private_class_method :new
end
