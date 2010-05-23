class Reddit
  @queue = :search_request
  FIELDS = ["author", "over_18", "permalink", "url", "ups", "num_comments", "score", "domain", "downs", "subreddit", "title"]
  URL = "http://api.reddit.com/search?q=%s" 
  DOMAIN = "reddit.com"
  NAME = "reddit"
  IDENTITY = ["author", "title"]

  def self.perform(query)
    response = Curl::Easy.perform(URL % query)
    parser = Yajl::Parser.new
    results = parser.parse(response.body_str)["data"]["children"]
    site = Site.first(:domain => DOMAIN)
    results.map!{|res| res["data"] }
    results.each do |result|
      id = result.delete('id')
      result.merge!('true_id' => id)
      search_result = site.search_results.first(result.only(*IDENTITY).merge(:query => query))
      if search_result
        search_result.set(result.only(*FIELDS))
      else
        description = result['selftext']
        site.search_results.create result.only(*FIELDS).merge(:query => query, :description => description)
      end
    end
  end
end
