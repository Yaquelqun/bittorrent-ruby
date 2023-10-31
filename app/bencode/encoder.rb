# frozen_string_literal: true

module Bencode
  class Encoder
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def call
      send("encode_#{FormatFinder.decoded_format(input)}")
    end

    private

    def encode_string
      "#{input.length}:#{input}"
    end

    def encode_integer
      "i#{input}e"
    end

    def encode_list
      result = ""
      input.each do |element|
        result += Encoder.new(element).call
      end

      "l#{result}e"
    end

    def encode_dictionnary
      @input = input.to_a.flatten
      result = encode_list[1..-2]

      "d#{result}e"
    end
  end
end