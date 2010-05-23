class Site
	include MongoMapper::Document

	many :search_results
	many :searches
	alias :results :search_results

  key :name, String

  def self.search(query)
    return if query.blank?
    all.each do |site|
      site.search(query)
    end
  end

  def search(query)
    search = searches.first(:query => query)
    search = searches.create(:query => query) unless search
    if !search.last_checked || search.last_checked < 1.hour.ago
      search.set :last_checked => Time.now
      begin 
        job_class = name.camelcase.constantize
        Resque.enqueue(job_class, query)
      rescue => e
        $stderr << "failed to create job for site #{name}: #{e.message}"
      end
    end
  end
end
