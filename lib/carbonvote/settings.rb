require 'yaml'
require 'singleton'
require 'redis'

module Carbonvote
  class Settings
    include Singleton

    SETTINGS_FILE = File.expand_path('../../../settings.yml', __FILE__)

    attr_reader :settings

    def initialize
      @settings = YAML::load_file SETTINGS_FILE
    end

    def redis
      Redis.new(url:  settings[:redis])
    end
  end
end
