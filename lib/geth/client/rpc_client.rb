require "net/http"

module Geth
  module Client
    class RpcClient < Base
      attr_accessor :endpoint

      def initialize(endpoint: nil, logger: nil)
        super(logger)
        @endpoint = endpoint
      end

      def send(method, params=[])
        http         = Net::HTTP.new(uri.host, uri.port)
        request      = Net::HTTP::Post.new(uri.request_uri)
        request.add_field('Content-Type', 'application/json')
        request.body = jsonrpc_encode(method, params)
        response     = http.request(request)
        response.body
      end

      def uri
        @uri ||= URI.parse(endpoint)
      end
    end
  end
end
