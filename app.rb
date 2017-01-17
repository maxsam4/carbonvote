require 'sinatra/base'

class Carbonvote < Sinatra::Base
  get '/' do
    erb :index
  end
end
