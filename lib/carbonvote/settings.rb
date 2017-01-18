require 'yaml'
require 'singleton'

module Carbonvote
  class Settings
    include Singleton

    SETTINGS_FILE = File.expand_path('../../../settings.yml', __FILE__)

    attr_reader :settings

    def initialize
      @settings = YAML::load_file SETTINGS_FILE
    end

    def redis_url
      settings[:redis_url]
    end

    def redis
      Redis.new(url: redis_url)
    end

    def start_block_number
      settings[:start_block_number]
    end

    def end_block_number
      settings[:end_block_number]
    end
  end
end
