require 'json' # used for display
require "ostruct" # useful for easier state management
require 'digest' # used for the hash

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
  encoded_torrent = File.read(file_path, encoding: 'iso-8859-1')
  state = Bencode::StateManager.build_initial_state(encoded_torrent)
  result, = Bencode::Decoder.new(state).call
  info_hash = Digest::SHA1.hexdigest(Bencode::Encoder.new(result['info']).call)
  pieces = result.dig('info', 'pieces').unpack1('H*').split('') # Magic trick to get the binary in the torrent turned into proper characters

  puts "Tracker URL: #{result['announce']}"
  puts "Length: #{result.dig('info', 'length')}"
  puts "Info Hash: #{info_hash}"
  puts "Piece Length: #{result.dig('info', 'piece length')}"

  puts "Piece Hashes:"
  # Kinda cheating, but since we want 20 binary char per line and it only takes 2 characters
  # to encode it in hexa, we can put characers 40 per 40
  puts pieces.shift(40).join('') until pieces.empty?
end

