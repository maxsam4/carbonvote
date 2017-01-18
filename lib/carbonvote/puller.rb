require 'redis'

module Carbonvote
  class Puller
    attr_reader :stop, :node, :logger, :redis,
                :start_block_number, :end_block_number

    def initialize(node: nil, logger: nil, settings: Settings.instance)
      @stop               = false
      @node               = node
      @logger             = logger
      @redis              = settings.redis
      @start_block_number = settings.start_block_number
      @end_block_number   = settings.end_block_number
    end

    def pull
      current_block_number = node.block_number

      if (processed_number >= end_block_number)
        logger.info("Reach the end of block number: #{end_block_number}")
        @stop = true
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

    def process(block_number)
      block_data = node.block(block_number, true)

      puts block_data

      update_processed_number(block_number)
    end

    def processed_number
      redis.get('processed_block_number' || start_block_number).to_i
    end

    def update_processed_number(number)
      redis.set 'processed_block_number', number
    end
  end
end
