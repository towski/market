require File.dirname(__FILE__) + "/../../test_helper"

context "Google" do
  setup do
    clear Site, SearchResult
  end

  test "searches based on a query, stores results" do
    query = 'you'
    site = Site.create(:domain => Google.domain)
    response = mock(Object)
    response.body_str { '{"responseData": {"results":[{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://www.something.com/","url":"http://www.something.com/","visibleUrl":"www.something.com","cacheUrl":"http://www.google.com/search?q\u003dcache:Wag9OPNjitUJ:www.something.com","title":"\u003cb\u003eSomething\u003c/b\u003e.","titleNoFormatting":"Something.","content":"\u003cb\u003eSomething\u003c/b\u003e."}]}}' }
    mock(Curl::Easy).perform(Google.url % query){ response }
    Google.perform(query)
    site.reload
    assert site.results.size == 1
    results = site.results.all(:query => query)
    assert results.size == 1
    result = results.first
    assert result.url
    assert result.title
    assert result.description
  end

  test "only updates results with the same username and name" do
    query = "you"
    site = Site.create(:domain => Google.domain)
    site.search_results.create :query => query, :url => "hey"
    response = mock(Object)
    response.body_str { '{"responseData": {"results":[{"url":"hey"}]}}' }
    mock(Curl::Easy).perform(Google.url % query){ response }
    Google.perform(query)
    assert site.results.size == 1
  end
end
#{"responseData": {"results":[{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://www.something.com/","url":"http://www.something.com/","visibleUrl":"www.something.com","cacheUrl":"http://www.google.com/search?q\u003dcache:Wag9OPNjitUJ:www.something.com","title":"\u003cb\u003eSomething\u003c/b\u003e.","titleNoFormatting":"Something.","content":"\u003cb\u003eSomething\u003c/b\u003e."},{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://en.wikipedia.org/wiki/Something","url":"http://en.wikipedia.org/wiki/Something","visibleUrl":"en.wikipedia.org","cacheUrl":"http://www.google.com/search?q\u003dcache:sB2y-Xxi2FIJ:en.wikipedia.org","title":"\u003cb\u003eSomething\u003c/b\u003e - Wikipedia, the free encyclopedia","titleNoFormatting":"Something - Wikipedia, the free encyclopedia","content":"\u0026quot;\u003cb\u003eSomething\u003c/b\u003e\u0026quot; is a song released by The Beatles in 1969. It was featured on the   album Abbey Road, and was also the first song written by George Harrison to \u003cb\u003e...\u003c/b\u003e"},{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://www.somethingawful.com/","url":"http://www.somethingawful.com/","visibleUrl":"www.somethingawful.com","cacheUrl":"http://www.google.com/search?q\u003dcache:_XSnxapFBXoJ:www.somethingawful.com","title":"\u003cb\u003eSomething\u003c/b\u003e Awful: The Internet Makes You Stupid","titleNoFormatting":"Something Awful: The Internet Makes You Stupid","content":"May 22, 2010 \u003cb\u003e...\u003c/b\u003e SomethingAwful.com offers daily internet news, reviews of horrible movies, games  , and social networking, anime and adult parody, \u003cb\u003e...\u003c/b\u003e"},{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://www.somethingstore.com/","url":"http://www.somethingstore.com/","visibleUrl":"www.somethingstore.com","cacheUrl":"http://www.google.com/search?q\u003dcache:eXBDshQSCcwJ:www.somethingstore.com","title":"The \u003cb\u003eSomething\u003c/b\u003e Store: Buy \u003cb\u003eSomething\u003c/b\u003e at SomethingStore.com","titleNoFormatting":"The Something Store: Buy Something at SomethingStore.com","content":"SomethingStore.com, based in New York, sells \u0026#39;\u003cb\u003esomething\u003c/b\u003e\u0026#39; a randomly selected,   mysterious product which can be anything and the recipients only find out what   \u003cb\u003e...\u003c/b\u003e"}],"cursor":{"pages":[{"start":"0","label":1},{"start":"4","label":2},{"start":"8","label":3},{"start":"12","label":4},{"start":"16","label":5},{"start":"20","label":6},{"start":"24","label":7},{"start":"28","label":8}],"estimatedResultCount":"66100000","currentPageIndex":0,"moreResultsUrl":"http://www.google.com/search?oe\u003dutf8\u0026ie\u003dutf8\u0026source\u003duds\u0026start\u003d0\u0026hl\u003den\u0026q\u003dsomething"}}, "responseDetails": null, "responseStatus": 200}
