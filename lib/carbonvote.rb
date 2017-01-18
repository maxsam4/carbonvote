require_relative './carbonvote/database'
require_relative './carbonvote/pool'
require_relative './carbonvote/puller'
require_relative './carbonvote/settings'

module Carbonvote
  class << self
    def process(data)
      p data
    end
  end
end
