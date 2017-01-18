require 'redis'
require 'forwardable'

module Carbonvote
  class Puller
    extend Forwardable

    delegate [:redis, :start_block_number,
              :end_block_number, :contract_addresses] => :settings

    attr_reader :finished, :node, :logger, :settings

    def initialize(node: nil, logger: nil, settings: nil)
      @finished = false
      @node     = node
      @logger   = logger
      @settings = settings
    end

    def pull
      current_block_number = node.block_number

      if (processed_number >= end_block_number)
        logger.info("Reach the end of block number: #{end_block_number}")
        @finished = true
      elsif current_block_number - processed_number <= 6 # for just in case chain header might revert
        sleep 15
      else
        process(processed_number.next)
      end
    rescue => e
      logger.debug e.message
      logger.debug e.backtrace.join("\n")
      raise e
    end

    def pool
      @pool ||= begin
                  addresses = contract_addresses.map do |name, addr|
                    Carbonvote::Contract.new(name: name, address: addr)
                  end

                  Carbonvote::Pool.new(addresses: addresses, node: node)
                end
    end

    def process(block_number)
      block_data = node.block(block_number, true)
      pool.process block_data
      update_processed_number(block_number)
    end

    def processed_number
      if number = redis.get('processed_block_number')
        number.to_i
      else
        start_block_number
      end
    end

    def update_processed_number(number)
      redis.set 'processed_block_number', number
    end
  end
end
