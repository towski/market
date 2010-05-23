require File.dirname(__FILE__) + "/../../test_helper"

context "Github" do
  setup do
    clear Site, SearchResult
  end

  test "searches based on a query, stores results" do
    query = 'you'
    site = Site.create(:domain => Reddit.domain)
    response = mock(Object)
    response.body_str { '{"data":{"children":[{"data":{"name":"t3_9poe8", "permalink":"/r/minimal/comments/9poe8/supermayer_hey_hotties/", "over_18":false, "is_self":false, "ups":3, "num_comments":0, "title":"SuperMayer - Hey Hotties!", "author":"stiffy420", "thumbnail":"http://thumbs.reddit.com/t3_9poe8.png", "created_utc":1254353133.0, "url":"http://www.youtube.com/watch?v=zmcwPSW8Pkk", "domain":"youtube.com", "id":"9poe8", "selftext":"", "media":{"video_id":"zmcwPSW8Pkk", "type":"youtube.com"}, "clicked":false, "subreddit_id":"t5_2r1xn", "selftext_html":null, "media_embed":{"scrolling":false, "height":295, "content":"&lt;object width=\"490\" height=\"295\"&gt;&lt;param name=\"movie\" value=\"http://www.youtube.com/v/zmcwPSW8Pkk&amp;fs=1\"&gt;&lt;/param&gt;&lt;param name=\"wmode\" value=\"transparent\"&gt;&lt;/param&gt;&lt;param name=\"allowFullScreen\" value=\"true\"&gt;&lt;/param&gt;&lt;embed src=\"http://www.youtube.com/v/zmcwPSW8Pkk&amp;fs=1\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" allowFullScreen=\"true\" width=\"480\" height=\"295\"&gt;&lt;/embed&gt;&lt;/object&gt;", "width":480}, "score":3, "saved":false, "created":1254353133.0, "downs":0, "hidden":false, "likes":null, "subreddit":"minimal"}}]}}' }
    mock(Curl::Easy).perform(Reddit.url % query){ response }
    Reddit.perform(query)
    site.reload
    assert site.results.size == 1
    result = site.results.all(:query => query).first
    assert result
    assert result.url
  end

  test "only updates results with the same true id" do
    query = "you"
    site = Site.create(:domain => Reddit.domain)
    site.search_results.create :query => query, :true_id => "chuck"
    response = mock(Object)
    response.body_str { '{"data":{"children":[{"data":{"id":"chuck","query":"?"}}]}}' % query }
    mock(Curl::Easy).perform(Reddit.url % query){ response }
    Reddit.perform(query)
    assert site.results.size == 1
  end
end
