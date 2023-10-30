# frozen_string_literal: true

# Needed a place to put that method
module Bencode
  module FormatFinder
    extend self

    def format(input)
      case input[0].chr
      when /\d/
        :string
      when 'i'
        :integer
      when 'l'
        :list
      when 'd'
        :dictionary
      else
        puts "unsupported_format"
        exit(1)
      end
    end
  end
end
