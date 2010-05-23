class Search
  include MongoMapper::Document
  
  belongs_to :site

  key :last_checked, Time
end
