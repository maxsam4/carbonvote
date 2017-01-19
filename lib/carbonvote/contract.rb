module Carbonvote
  class Contract
    attr_reader :node, :name, :address, :redis

    def initialize(node: nil, name: '', address: '')
      settings = Settings.instance

      @node    = node
      @name    = name
      @address = address
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

    def vote(account, block_number)
      balance = node.balance(account, block_number)

      redis.pipelined do
        redis.hset(address, account, balance)
        redis.incrbyfloat(amount_key, balance)
      end
    end

    def update_balance(account, block_number)
      return if account.nil?

      if balance = redis.hget(address, account)
        new_balance = node.balance(account, block_number)

        redis.pipelined do
          redis.incrbyfloat(amount_key, -balance.to_f)
          redis.incrbyfloat(amount_key, new_balance)
          redis.hset(address, account, new_balance)
        end
      end
    end
  end
end
