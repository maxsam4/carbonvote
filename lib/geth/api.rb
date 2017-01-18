module Geth
  module API
    extend ActiveSupport::Concern

    included do
      API_LIST = [
        {
          name: :block,
          call: :eth_getBlockByNumber,
          input_formatter: [:umber_to_hex,
                            :default_bool_option_false]
        },
        {
          name: :block_number,
          call: :eth_blockNumber,
          input_formatter: [],
          output_formatter: :hex_to_number
        },
        {
          name: :balance,
          call: :eth_getBalance,
          input_formatter: [:format_address,
                            :default_block_option_pending],
          output_formatter: :wei_to_ether
        },
        {
          name: :transaction_receipt,
          call: :eth_getTransactionReceipt,
          input_formatter: [:format_txid]
        },
        {
          name: :eth_call,
          call: :eth_call,
          input_formatter: [:format_raw_transaction,
                            :default_block_option_latest]
        },
        {
          name: :balance_of,
          call: :eth_call,
          input_formatter: [:format_balance_of_eth_call,
                            :default_block_option_latest],
          output_formatter: :hex_to_number
        },
        {
          name: :compile_contract,
          call: :eth_compileSolidity,
          input_formatter: [:format_contract]
        },
        {
          name: :transaction_count,
          call: :eth_getTransactionCount,
          input_formatter: [:format_address,
                            :default_block_option_pending]
        },
        {
          name: :gas_price,
          call: :eth_gasPrice,
          input_formatter: []
        },
        {
          name: :send_raw_transaction,
          call: :eth_sendRawTransaction,
          input_formatter: [:format_raw_transaction]
        },
        {
          name: :estimate_gas,
          call: :eth_estimateGas,
          input_formatter: [:format_raw_transaction]
        }
      ]
    end
  end
end
