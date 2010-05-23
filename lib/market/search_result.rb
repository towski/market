class SearchResult
  include MongoMapper::Document

  belongs_to :site
  ensure_index :query
  ensure_index :clicks

  key :query, String
  key :clicks, Integer, :default => 0

  def self.popular(search_options)
    SearchResult.all({:limit => 10, "order" => "clicks desc, score desc"}.merge(search_options))
  end
end
