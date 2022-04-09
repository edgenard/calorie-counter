require "jwt"

class RequestToken
  def self.encode(payload, expiration = 12.hours.from_now)
    payload[:exp] = expiration.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)[0].symbolize_keys
  end
end
