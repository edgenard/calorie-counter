require_relative "../../lib/request_token"

class AuthenticateUser
  include Dry::Monads[:result]

  # params {email: string, password: string}
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      Success(user: user, token: RequestToken.encode({user_id: user.id}))
    else
      Failure("Invalid Credentials")
    end
  end

  private

  attr_reader :params

  private_class_method :new
end
