require 'sinatra/base'
require "sinatra/reloader"
require "sinatra/config_file"
require "sinatra/json"

require_relative 'lib/Carbonvote'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  register Sinatra::ConfigFile
  config_file 'settings.yml'

  helpers do
    def redis
      @redis ||= Redis.new(url: settings.redis_url)
    end

    def last_block
      redis.get('processed-block-number') || 0
    end

    def get_amount(name)
      key = settings.contract_addresses[name]
      (redis.get("#{key}-amount") || 0).to_f
    end

    def yes_vote_amount
      [
        get_amount(:yes_contract_1),
        get_amount(:yes_contract_2),
        get_amount(:yes_contract_3),
        get_amount(:yes_contract_4),
        get_amount(:yes_contract_5)
      ].sum.round(4)
    end

    def no_vote_amount
      get_amount(:no_contract).round(4)
    end
  end

  get '/' do
    erb :index, locals: {
      settings: settings,
      last_block: last_block,
      no_vote_amount: no_vote_amount,
      yes_vote_amount: yes_vote_amount
    }
  end

  get '/vote' do
    json yes: yes_vote_amount, no: no_vote_amount
  end
end
