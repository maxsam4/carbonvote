require 'redis'
require 'forwardable'

require_relative 'carbonvote/pool'
require_relative 'carbonvote/puller'
require_relative 'carbonvote/settings'

module Carbonvote
  VERSION = '2.0.0'
end
