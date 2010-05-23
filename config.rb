$LOAD_PATH << './lib'

gem 'sinatra', "= 1.0"
require 'sinatra'

gem 'bson_ext', "= 1.0"
gem 'mongo_mapper', "= 0.7.6"
require 'mongo_mapper'

if $APP_ENV == "test"
	MongoMapper.database = 'market_test'
else
	MongoMapper.database = 'market'
end

gem "curb", "= 0.7.3"
require "curb"

require 'yajl'

gem 'resque'
require 'resque'

require 'market'
if $APP_ENV == "production"
  Api.set :environment, :production
else
  Api.set :environment, :development
end
Api.set :public, File.dirname(__FILE__) + '/public'

class Hash
  def only(*allowed)
    hash = {}
    allowed.each {|k| hash[k] = self[k] if self.has_key?(k) }
    hash
  end
end

