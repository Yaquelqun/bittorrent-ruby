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
when "info"
  file_path = ARGV[1]
  encoded_torrent = File.read(file_path, encoding: 'iso-8859-1')
  decoded_torrent = BencodeDecoder.new(encoded_torrent).call
  puts "Tracker URL: #{decoded_torrent['announce']}"
  puts "Length: #{decoded_torrent.dig('info', 'length')}"
end

