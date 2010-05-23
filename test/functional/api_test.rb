require File.dirname(__FILE__) + "/../test_helper"
require 'rack/test'

#puts last_request.env['sinatra.error']
context "Api" do
  include Rack::Test::Methods

  setup do
    clear Site, SearchResult
  end

  def app
    Api.new
  end

  test "querying makes a job for each site and returns results" do
    Site.create :name => "github"
    post '/', :query => "hey"
    assert Resque.reserve(:search_request)
    assert last_response.ok?
  end

  test "form page" do
    get '/'
    assert last_response.ok?
  end

  test "increment clicks" do
    search_result = SearchResult.create :query => "towski"
    get "/links/#{search_result.id}/increment"
    assert search_result.reload.clicks == 1
    assert last_response.ok?
  end
end
