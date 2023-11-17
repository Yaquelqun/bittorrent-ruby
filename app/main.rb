require 'json' # used for display
require "ostruct" # useful for easier state management
require 'digest' # used for the hash

Dir["./app/bencode/*.rb"].each { |file| require file }
require_relative 'torrent'

if ARGV.length < 2
  puts "Usage: your_bittorrent.sh <command> <args>"
  exit(1)
end

def decode(input:, from: :path)
  input = File.read(input, encoding: 'iso-8859-1') unless from == :string
  state = Bencode::StateManager.build_initial_state(input)
  result, = Bencode::Decoder.new(state).call
  result
end

command = ARGV[0]
case command
when "decode"
  puts JSON.generate(decode(input: ARGV[1], from: :string))
when "info"
  torrent = Torrent.new(decode(input: ARGV[1]))
  torrent.display_details
when "peers"
  torrent = Torrent.new(decode(input: ARGV[1]))
  puts torrent.peers
end

