require 'redis'

class Puller
  attr_reader :node, :logger

  def initialize(node: nil, logger: nil)
    @node   = node
    @logger = logger
  end

  def pull
    current_block_number  = node.block_number
    last_processed_number = 0

    case current_block_number - last_processed_number
    when 0..6
      sleep 15
    else
      pull_data(last_processed_number.zero? ? 0 : last_processed_number.next)
    end
  rescue => e
    logger.debug e.message
    logger.debug e.backtrace.join("\n")
    raise e
  end

  def pull_data(block_number)
    puts node.block(block_number, true)
  end
end
