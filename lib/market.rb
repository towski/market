require 'market/api'
require 'market/search_result'
require 'market/site'
require 'market/search'
require 'market/query'
require 'market/job'
Dir['lib/market/jobs/*'].each do |job|
	require job
end
