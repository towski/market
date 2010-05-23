require File.dirname(__FILE__) + "/../../test_helper"

context "Github" do
  setup do
    clear Site, SearchResult
  end

  test "searches based on a query, stores results" do
    query = 'you'
    site = Site.create(:domain => "github.com")
    response = mock(Object)
    response.body_str { '{"repositories":[{"name":"django-uni-form","size":1212,"followers":180,"language":"Python","fork":false,"username":"pydanny","id":"repo-163302","type":"repo","pushed":"2010-05-11T17:38:09Z","forks":24,"description":"Django forms are easily rendered as tables, paragraphs, and unordered lists. However, elegantly rendered div based forms is something you have to do by hand. The purpose of this application is to provide a simple tag and/or filter that lets you quickly render forms in a div format.","score":0.27105474,"created":"2009-03-30T15:41:10Z"}]}' }
    mock(Curl::Easy).perform("http://github.com/api/v1/json/search/#{query}"){ response }
    Github.perform(query)
    site.reload
    assert site.results.size == 1
    assert site.results.all(:query => query).size == 1
  end

  test "only updates results with the same username and name" do
    query = "you"
    site = Site.create(:domain => "github.com")
    site.search_results.create :query => query, :username => "towski", :name => "market"
    response = mock(Object)
    response.body_str { '{"repositories":[{"name":"market","username":"towski","query":"you"}]}' }
    mock(Curl::Easy).perform("http://github.com/api/v1/json/search/#{query}"){ response }
    Github.perform(query)
    assert site.results.size == 1
  end
end
