class Github
  @queue = :search_request
  URL = "http://github.com/api/v1/json/search/%s"
  DOMAIN = "github.com"
  IDENTITY = [:true_id]
  NAME = "github"

  def self.perform(query)
    response = Curl::Easy.perform(URL % query)
    parser = Yajl::Parser.new
    results = parser.parse(response.body_str)["repositories"]
    github = Site.first(:domain => DOMAIN)
    #sort by the github score, insert the lower score results first
    results.sort_by{|res| res["score"] }
    results.each do |result|
      id = result.delete('id')
      result.merge!('true_id' => id)
      repo_name = result["name"]
      user_name = result["username"]
      search_result = github.search_results.first(:query => query, :username => user_name, :name => repo_name)
      if search_result
        search_result.set(result)
      else
        url = "http://github.com/#{user_name}/#{repo_name}"
        github.search_results.create result.merge(:query => query, :url => url, :title => "#{repo_name} - #{user_name} - #{result["language"]} repository")
      end
    end
  end
end
