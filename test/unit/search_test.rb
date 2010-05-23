require File.dirname(__FILE__) + "/../test_helper"

context "SearchResult" do
  setup do
    Resque.remove_queue(:search_request)
    clear SearchResult
  end

  test "sites can search to trigger a job" do
    site = Site.first_or_create :name => "github", :domain => "github.com"
    search = site.search "hey"
    assert Resque.reserve(:search_request)
    assert site.searches.size == 1
  end

  test "sites can search to trigger a job if it was last checked over an hour ago" do
    site = Site.first_or_create :name => "github", :domain => "github.com"
    site.searches.create :query => "hey", :last_checked => 2.hours.ago
    search = site.search "hey"
    assert Resque.reserve(:search_request)
  end

  test "sites can only trigger searches once per hour per query" do
    site = Site.first_or_create :name => "github", :domain => "github.com"
    search = site.search "hey"
    Resque.reserve(:search_request)
    search = site.search "hey"
    assert_nil Resque.reserve(:search_request)
    assert site.searches.size == 1
  end

  test "empty searches don't trigger async searches" do
    site = Site.first_or_create :name => "github", :domain => "github.com"
    search = Site.search ""
    assert_nil Resque.reserve(:search_request)
  end

  test "sites can have search results from jobs" do
    site = Site.first_or_create :name => "github", :domain => "github.com"
    search_result = site.search_results.create :query => "technoweenie", :result => "http://github.com/technoweenie"
    assert site.search_results.first.site == site
  end

  test "returns popular results by number of clicks" do
    search_result1 = SearchResult.create :clicks => 1, :query => "hey"
    search_result2 = SearchResult.create :clicks => 2, :query => "hey"
    assert SearchResult.popular("query" => "hey") == [search_result2, search_result1]
  end

  test "popular parses the search query and uses it to search" do
    search_result = SearchResult.create! :blood_alcohol_level => "1.23"
    assert SearchResult.popular("blood_alcohol_level" => "1.23") == [search_result]
  end

  test "can choose an arbitrary ordering" do
    search_result2 = SearchResult.create! :bac => "1.22"
    search_result1 = SearchResult.create! :bac => "1.23"
    assert SearchResult.popular("order" => "bac desc") == [search_result1, search_result2]
  end
end
