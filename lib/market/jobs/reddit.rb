class Reddit < Job
  class << self
    def url
      "http://api.reddit.com/search?q=%s" 
    end

    def domain
      "reddit.com"
    end

    def name
      "reddit"
    end

    def prepare_results(results)
      results = results["data"]["children"]
      results.map{|res| res["data"] }
    end

    def identity(result)
      result.only("author", "title")
    end

    def fields(result)
      result.only("author", "over_18", "permalink", "url", "ups", "num_comments", "score", "domain", "downs", "subreddit", "title").merge("description" => result['selftext'].to_s)
    end
  end
end
