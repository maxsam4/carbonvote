module Geth
  module Client
    class IpcClient < Base
      attr_accessor :ipcpath

      def initialize(endpoint: nil, logger: nil)
        super(logger)
        @ipcpath = endpoint || default_ipcpath
      end

      def send(method, params=[])
        tries = 0

        begin
          socket.puts jsonrpc_encode(method, params)
          socket.gets
        rescue Errno::EPIPE => e
          tries += 1
          if tries <= 3
            sleep(15)
            logger.info "Retry connect to IPC backend times: #{tries}"
            reconnect
            retry
          else
            raise e
          end
        end
      end

      def socket
        @socket ||= UNIXSocket.new(ipcpath)
      end

      def reconnect
        @socket = nil; true
      end

      def close
        socket.close
      end

      private

      def default_ipcpath
        case RUBY_PLATFORM
        when /darwin/ then
          ENV['HOME'] + '/Library/Ethereum/geth.ipc'
        when /linux/ then
          ENV['HOME'] + '/.ethereum/geth.ipc'
        end
      end
    end
  end
end
