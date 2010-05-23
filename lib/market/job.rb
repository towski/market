class Job
  def self.inherited(klass)
    klass.instance_variable_set("@queue",:search_request)
  end

  class << self
    def url
      raise  "url is unimplemented"
    end

    def domain
      raise  "domain is unimplemented"
    end

    def name
      raise  "name is unimplemented"
    end
    
    def identity(result)
      raise  "identity is unimplemented"
    end

    def fields(result)
      raise  "fields is unimplemented"
    end

    def prepare_results(results)
      results
    end

    def merge_id(result)
      if result["id"]
        id = result.delete('id')
        result.merge!('true_id' => id)
      end
    end

    def perform(query)
      site = Site.first(:domain => domain)
      response = Curl::Easy.perform(url % query)
      parser = Yajl::Parser.new
      results = parser.parse(response.body_str)
      results = prepare_results(results)
      results.each do |result|
        merge_id(result)
        search_result = site.search_results.first(identity(result).merge(:query => query))
        if search_result
          search_result.set(fields(result))
        else
          site.search_results.create fields(result).merge(:query => query)
        end
      end
    end
  end
end
