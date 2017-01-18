require_relative 'formatter'

module Geth
  class Payload

    attr_reader :args, :input_formatter, :formatter

    def initialize(args: [], input_formatter: [])
      @args            = *args
      @input_formatter = input_formatter
      @formatter       = Geth::Formatter
    end

    def as_json(options={})
      return [] if input_formatter.length == 0

      [].tap do |result|
        input_formatter.each_with_index do |f, i|
          result << @formatter.send(f, args[i])
        end
      end
    end

  end
end
