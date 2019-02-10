module Carbonvote
  class Contract
    attr_reader :node, :name, :address, :logger, :redis

    def initialize(node: nil, name: '', address: '')
      settings = Settings.instance

      @node    = node
      @name    = name
      @address = address
      @logger = Logger.new(STDOUT)
      @redis   = settings.redis
    end

    def amount_key
      @amount_key ||= [address, 'amount'].join('-')
    end

    def clear_previous_vote(account)
      if balance = redis.hget(address, account)
        redis.hdel(address, account)
        redis.incrbyfloat(amount_key, -balance.to_f)
      end
    end

    def vote(account)
      logger.info account
      balance = node.balance(account)
      logger.info balance
      redis.pipelined do
        redis.hset(address, account, balance)
        redis.incrbyfloat(amount_key, balance)
      end
    end

    def update_balance(account)
      return if account.nil?

      if balance = redis.hget(address, account)
        new_balance = node.balance(account)

        redis.pipelined do
          redis.incrbyfloat(amount_key, -balance.to_f)
          redis.incrbyfloat(amount_key, new_balance)
          redis.hset(address, account, new_balance)
        end
      end
    end
  end
end
