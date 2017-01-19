require 'redis'
require 'forwardable'

module Carbonvote
  class Puller
    extend Forwardable

    delegate [:redis, :start_block_number,
              :end_block_number, :contract_addresses] => :settings

    attr_reader :finished, :node, :logger, :settings, :pool

    def initialize(node: nil, logger: nil)
      @finished = false
      @node     = node
      @logger   = logger
      @settings = Settings.instance
      @pool     = Carbonvote::Pool.new(node: node)
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

    private

    def process(block_number)
      block = node.block(block_number)
      block['transactions'].each do |tx_id|
        pool.process tx_id, block_number
      end
      update_processed_number(block_number)
    end

    def processed_number
      if number = redis.get('processed-block-number')
        number.to_i
      else
        start_block_number
      end
    end

    def update_processed_number(number)
      redis.set 'processed-block-number', number
    end
  end
end
