require 'json'

module Geth
  module Client
    class Base
      attr_accessor :logger

      def initialize(logger)
        @logger = logger
        @req_id = 0
      end

      def req_id
        @req_id += 1
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def jsonrpc_encode(method, params)
        if params.is_a? Geth::Payload
          params = params.as_json
        end

        JSON.generate({
          jsonrpc: '2.0', method: method, params: params, id: req_id
        })
      end
    end
  end
end
