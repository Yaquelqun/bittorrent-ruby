require 'json'
require_relative 'bencode_decoder'

if ARGV.length < 2
  puts "Usage: your_bittorrent.sh <command> <args>"
  exit(1)
end

command = ARGV[0]

case command
when "decode"
  encoded_str = ARGV[1]
  decoded_str = BencodeDecoder.new(encoded_str).call
  puts JSON.generate(decoded_str)
end

