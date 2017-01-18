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

    def redis
      Redis.new(url: redis_url)
    end

    [
      :redis_url,
      :start_block_number,
      :end_block_number,
      :contract_addresses,
      :black_list
    ].each do |method_name|
      define_method method_name do
        settings[method_name]
      end
    end
  end
end
