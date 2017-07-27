require_relative 'geth/formatter'
require_relative 'geth/payload'
require_relative 'geth/node'
require_relative 'geth/client/base'
require_relative 'geth/client/ipc_client'
require_relative 'geth/client/rpc_client'

module Geth
  class << self
    def new(endpoint: nil, logger: nil)
      endpoint = endpoint
      logger   = logger

      Geth::Node.new(client(endpoint, logger))
    end

    private

    def client(endpoint, logger)
      if endpoint&.start_with?("http")
        Geth::Client::RpcClient.new(endpoint: endpoint, logger: logger)
      else
        Geth::Client::IpcClient.new(endpoint: endpoint, logger: logger)
      end
    end
  end
end

