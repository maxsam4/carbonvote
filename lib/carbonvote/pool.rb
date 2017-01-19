module Carbonvote
  class Pool
    attr_reader :node, :formatter, :redis,
                :addresses, :contracts, :black_addresses

    def initialize(node: nil)
      settings   = Settings.instance

      @node      = node
      @formatter = Geth::Formatter
      @redis     = settings.redis
      @addresses = settings.contract_addresses.values
      @contracts = settings.contract_addresses.map do |name, addr|
        Contract.new(name: name, address: addr)
      end

      @black_addresses = settings.black_list.values
    end

    def process(block_number, tx_id)
      return if processed?(tx_id)

      receipt = node.transaction_receipt(tx_id)
      return if receipt.nil?
      return if receipt['logs'].empty?

      if vote?(receipt)
        vote(block_number, tx_id, receipt)
      else
        update_balance(receipt)
      end
    end

    def processed?(tx_id)
      redis.sismember 'processed-tx-ids', tx_id
    end

    def processed!(tx_id)
      redis.sadd 'processed-tx-ids', tx_id
    end

    def vote?(receipt)
      (addresses & receipt['logs'].map {|log| log['address']}).any?
    end

    def vote(block_number, tx_id, receipt)
      data = receipt['logs'].select {|log| addresses.include?(log['address'])}[0]

      account = @formatter.format_address(data['topics'][1])
      return if black_list?(account)

      # voting
      contracts.each do |contract|
        contract.clear_previous_vote(account)

        if contract.address == data['address']
          balance = node.balance(account, block_number)
          contract.vote(tx_id, account, balance)
        end
      end

      processed!(tx_id)
    end

    def update_balance(receipt)
      contracts.each do |contract|
        contract.update_balance(receipt)
      end
    end

    def black_list?(account)
      black_addresses.include?(account)
    end

  end
end
