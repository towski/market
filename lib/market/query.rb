class Query
  def self.parse(query)
    search_options = HashWithIndifferentAccess.new
    query.scan(/[a-zA-Z_]+:[^ ]+/).each do |search|
      key, value = search.split(":")
      search_options[key] = value
    end
    query.gsub!(/[a-zA-Z_]+:[^ ]+/,'')
    query.strip!
    search_options[:query] = query unless query.blank?
    search_options[:order] += " desc" if search_options[:order]
    search_options
  end
end
