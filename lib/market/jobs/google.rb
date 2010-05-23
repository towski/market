class Google < Job
  class << self
    def url
      "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=%s"
    end

    def domain
      "google.com"
    end

    def name
      "google"
    end

    def identity(result)
      {:url => result["url"]}
    end

    def prepare_results(results)
      results["responseData"]["results"]
    end

    def fields(result)
      {"url" => result["url"], "description" => result["content"], "title" => result["titleNoFormatting"]}
    end
  end
end
