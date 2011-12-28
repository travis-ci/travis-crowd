# http://pivotallabs.com/users/mgehard/blog/articles/1595-testing-omniauth-based-login-via-cucumber

OmniAuth.config.test_mode = true

module Accounts
  PAYLOADS = {
    twitter: {
      svenfuchs: {
        provider: 'twitter',
        uid: '12345678',
        info: {
          name: 'Sven Fuchs',
          nickname: 'svenfuchs',
          description: 'My bio',
          urls: {
            website: 'http://svenfuchs.com'
          }
        }
      }
    }
  }

  def oauth_payload_for(provider, name)
    Hashr.new(PAYLOADS[provider.to_sym][name.to_sym])
  end
end

World(Accounts)
