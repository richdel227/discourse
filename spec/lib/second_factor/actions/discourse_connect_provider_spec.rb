# frozen_string_literal: true

describe SecondFactor::Actions::DiscourseConnectProvider do
  fab!(:user) { Fabricate(:user) }
  sso_secret = "mysecretmyprecious"
  let!(:sso) do
    sso = ::DiscourseConnectProvider.new
    sso.nonce = "mysecurenonce"
    sso.return_sso_url = "http://hobbit-shire.com/sso"
    sso.sso_secret = sso_secret
    sso.require_2fa = true
    sso
  end

  before do
    SiteSetting.enable_discourse_connect_provider = true
    SiteSetting.discourse_connect_provider_secrets = "hobbit-shire.com|#{sso_secret}"
  end

  def params(hash)
    ActionController::Parameters.new(hash)
  end

  def create_request(query_string)
    ActionDispatch::TestRequest.create({
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/",
      "QUERY_STRING" => query_string
    })
  end

  def params_from_payload(payload)
    ActionController::Parameters.new(Rack::Utils.parse_query(payload))
  end

  def create_instance(user, request = nil, opts = nil)
    request ||= create_request
    SecondFactor::Actions::DiscourseConnectProvider.new(Guardian.new(user), request, opts)
  end

  describe "#skip_second_factor_auth?" do
    it "returns true if there's no current_user" do
      request = create_request(sso.payload)
      params = params_from_payload(sso.payload)
      action = create_instance(nil, request)
      expect(action.skip_second_factor_auth?(params)).to eq(true)
    end

    it "returns true if SSO is for logout" do
      sso.logout = true
      request = create_request(sso.payload)
      params = params_from_payload(sso.payload)
      action = create_instance(user, request)
      expect(action.skip_second_factor_auth?(params)).to eq(true)
    end

    it "returns true if SSO doesn't require 2fa" do
      sso.require_2fa = false
      request = create_request(sso.payload)
      params = params_from_payload(sso.payload)
      action = create_instance(user, request)
      expect(action.skip_second_factor_auth?(params)).to eq(true)
    end

    it "returns true if 2fa has been confirmed during login" do
      request = create_request(sso.payload)
      params = params_from_payload(sso.payload)
      action = create_instance(user, request, confirmed_2fa_during_login: true)
      expect(action.skip_second_factor_auth?(params)).to eq(true)
    end

    it "returns falsey value otherwise" do
      request = create_request(sso.payload)
      params = params_from_payload(sso.payload)
      action = create_instance(user, request)
      expect(action.skip_second_factor_auth?(params)).to be_falsey
    end
  end

  describe "#second_factor_auth_skipped!" do
  end

  describe "#no_second_factors_enabled!" do
  end

  describe "#second_factor_auth_required!" do
  end

  describe "#second_factor_auth_completed!" do
  end
end
