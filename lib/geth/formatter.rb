require 'bigdecimal'

module Geth
  module Formatter

    UNITS = {
      wei:        1,
      kwei:       1000,
      ada:        1000,
      femtoether: 1000,
      mwei:       1000000,
      babbage:    1000000,
      picoether:  1000000,
      gwei:       1000000000,
      shannon:    1000000000,
      nanoether:  1000000000,
      nano:       1000000000,
      szabo:      1000000000000,
      microether: 1000000000000,
      micro:      1000000000000,
      finney:     1000000000000000,
      milliether: 1000000000000000,
      milli:      1000000000000000,
      ether:      1000000000000000000,
      eth:        1000000000000000000,
      kether:     1000000000000000000000,
      grand:      1000000000000000000000,
      einstein:   1000000000000000000000,
      mether:     1000000000000000000000000,
      gether:     1000000000000000000000000000,
      tether:     1000000000000000000000000000000
    }

    module_function

    ########################################
    # Data type convert methods
    ########################################

    def hex_to_number(val)
      val.to_s.to_i(16)
    end

    def number_to_hex(val)
      ["0x", val.to_s(16)].join
    end

    def wei_to_ether(hex_str, unit: :ether)
      return 0 if hex_str.nil? || hex_str.empty?
      (BigDecimal.new(hex_to_number(hex_str), 16) / BigDecimal.new(UNITS[unit.to_sym], 16)).to_f
    rescue
      0.0
    end

    ########################################
    # Argument formatter methods
    ########################################

    def format_contract(val)
      val
    end

    def format_raw_transaction(tx)
      tx
    end

    def format_address(val=nil)
      raise "blank address" if val.nil? || val.empty?
      ["0x", val[-40..-1]].join
    end

    def format_txid(val=nil)
      raise "blank address" if val.nil? || val.empty?
      ["0x", val[-64..-1]].join
    end

    def format_balance_of_eth_call(options)
      options  = options.to_options!
      contract = options[:contract_address]
      address  = options[:address]
      sign     = 'balanceOf(address)'

      {
        to: contract,
        data: [method_signature_to_payload(sign), address_to_payload(address)].join
      }
    end

    ########################################
    # Payload formatter methods
    ########################################

    def int_to_payload(num)
      (num & ((1 << 256) - 1)).to_s(16).rjust(64, '0')
    end

    def string_to_payload(str)
      str.b.unpack("H*").first.ljust(64, '0')
    end

    def address_to_payload(address)
      address.gsub(/^0x/,'').rjust(64, "0")
    end

    def method_signature_to_payload(method_sign)
      "0x" + Digest::SHA3.hexdigest(method_sign, 256)[0, 8]
    end

    ########################################
    # Output formatter methods
    ########################################

    def output_to_string(str)
      return '' if str == '0x'
      _, size_hex, data = str.to_s.gsub(/^0x/,'').scan(/.{64}/)
      [data[0, hex_to_number("0x" + size_hex) * 2]].pack("H*")
    end

    ########################################
    # Method missing
    ########################################

    def method_missing(method_name, *arguments, &block)
      if method_name.to_s =~ /default_block_option_(.*)/
        return arguments[0].nil? ? $1 : arguments[0]
      end

      if method_name.to_s =~ /default_bool_option_false/
        return !!arguments[0] || false
      end
    end

  end
end
