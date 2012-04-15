class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::MD5
    
    config.logged_in_timeout = 20.minutes
    config.validate_email_field = true
  end
end