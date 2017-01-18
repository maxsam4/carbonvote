module Carbonvote
  class Pool
    attr_reader :addresses, :node

    def initialize(addresses: [], node: nil)
      @addresses = addresses
      @node      = node
    end

    def process(data)
      transactions = data['transactions']
      transactions.each do |txid|
        tx_receipt = node.transaction_receipt(txid)
        p [txid, tx_receipt]
      end
    end
  end
end
