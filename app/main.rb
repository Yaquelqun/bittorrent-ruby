require 'json'
require "ostruct"

Dir["./app/bencode/*.rb"].each { |file| require file }

if ARGV.length < 2
  puts "Usage: your_bittorrent.sh <command> <args>"
  exit(1)
end

command = ARGV[0]

case command
when "decode"
  encoded_str = ARGV[1]
  state = Bencode::StateManager.build_initial_state(encoded_str)
  result, = Bencode::Decoder.new(state).call
  puts JSON.generate(result)
when "info"
  file_path = ARGV[1]
  encoded_torrent = File.read(file_path)
  state = Bencode::StateManager.build_initial_state(encoded_torrent)
  result, = Bencode::Decoder.new(state).call
  puts "Tracker URL: #{result['announce']}"
  puts "Length: #{result.dig('info', 'length')}"
end

