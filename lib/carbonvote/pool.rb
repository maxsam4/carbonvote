module Carbonvote
  class Pool
    attr_reader :node, :formatter, :redis, :logger,
                :addresses, :contracts, :black_addresses

    def initialize(node: nil)
      settings   = Settings.instance
      @logger = Logger.new(STDOUT)
      @node      = node
      @formatter = Geth::Formatter
      @redis     = settings.redis
      @addresses = settings.contract_addresses.values
      @contracts = settings.contract_addresses.map do |name, addr|
        Contract.new(node: node, name: name, address: addr)
      end

      @black_addresses = settings.black_list.values
    end

    def process(tx_id)
      receipt = node.transaction_receipt(tx_id)
      return if receipt.nil?
      if vote?(receipt)
        vote(tx_id, receipt)
      else
        update_balance(receipt)
      end
    end

    def vote?(receipt)
      (addresses & receipt['logs'].map {|log| log['address']}).any?
    end

    def vote(tx_id, receipt)
      data = receipt['logs'].select {|log| addresses.include?(log['address'])}[0]
      
      account = @formatter.format_address(data['topics'][1])
      
      return if black_list?(account)

      contracts.each do |contract|
        contract.clear_previous_vote(account)

        if contract.address == data['address']
          contract.vote(account)
        end
      end
    end

    def update_balance(receipt)
      contracts.each do |contract|
        contract.update_balance(receipt['from'])
        contract.update_balance(receipt['to'])
      end
    end

    def black_list?(account)
      black_addresses.include?(account)
    end
  end
end
