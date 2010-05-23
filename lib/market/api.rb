class Api < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
  use Rack::CommonLogger

  get '/' do
    erb :form
  end

  post '/' do 
    search_options = Query.parse(params[:query])
    @results = SearchResult.popular(search_options)
    Site.search search_options["query"]
    erb :index
  end
  
  get '/links/:id/increment' do
    search_result = SearchResult.first(:id => params[:id])
    if search_result
      search_result.increment(:clicks => 1)
    end
    200
  end
end
