RSpec.describe Okta::Jwt do

  CLIENT = Okta::Jwt

  CLIENT.configure! issuer_url:     ENV["OKTA_ISSUER_URL"],
                    auth_server_id: ENV["OKTA_AUTH_SERVER_ID"],
                    client_id:      ENV["OKTA_CLIENT_ID"],
                    client_secret:  ENV["OKTA_CLIENT_SECRET"],
                    logger:         Logger.new(STDOUT)

  auth_response = Okta::Jwt.sign_in(username: 'test@example.org', password: 'Password123')
  parsed_auth_response = JSON.parse(auth_response.body)

  it "has a version number" do
    expect(Okta::Jwt::VERSION).not_to be nil
  end

  it "does validates id_token" do
    expect(Okta::Jwt.verify_token(parsed_auth_response['id_token'])['exp']).to be_truthy
  end

  it "does validates access_token" do
    expect(Okta::Jwt.verify_token(parsed_auth_response['access_token'])['exp']).to be_truthy
  end

  it "does have cached jwk" do
    expect(Okta::Jwt::JWKS_CACHE.keys.size).to eq(1)
  end
end
