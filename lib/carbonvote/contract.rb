module Carbonvote
  class Contract

    attr_reader :address, :redis

    def initialize(name: '', address: '')
      settings = Settings.instance

      @name    = name
      @address = address
      @redis   = settings.redis
    end

    def clear_previous_vote(account)
      if balance = redis.hget(address, account)
        redis.hdel(address, account)
        redis.incrbyfloat("#{address}-amount", -balance.to_f)
      end
    end

    def vote(tx_id, account, balance)
      redis.pipelined do
        redis.hset address, account, balance
        redis.incrbyfloat("#{address}-amount", balance)
      end
    end

    def update_balance(tx)
      [tx['from'], tx['to']].each do |address|
      end
    end
  end
end
