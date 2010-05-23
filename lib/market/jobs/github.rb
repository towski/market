class Github < Job
  class << self
    def url
      "http://github.com/api/v1/json/search/%s"
    end

    def domain
      "github.com"
    end

    def name
      "github"
    end

    def identity(result)
      {:true_id => result["true_id"]}
    end

    def prepare_results(results)
      results = results["repositories"]
      #sort by the github score, insert the lower score results first
      results.sort_by{|res| res["score"] }
    end

    def fields(result)
      repo_name = result["name"]
      user_name = result["username"]
      url = "http://github.com/#{user_name}/#{repo_name}"
      result.merge(:url => url, :title => "#{repo_name} - #{user_name} - #{result["language"]} repository")
    end
  end
end
