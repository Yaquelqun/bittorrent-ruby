# frozen_string_literal: true

require 'forwardable'

class Torrent
  extend Forwardable

  def_delegators :@torrent, :info, :announce

  def initialize(torrent_hash)
    @torrent = OpenStruct.new(torrent_hash)
  end

  def display_details
    info_hash = Digest::SHA1.hexdigest(Bencode::Encoder.new(info).call)
    pieces = info['pieces'].unpack1('H*').split('') # Magic trick to get the binary in the torrent turned into proper characters

    puts "Tracker URL: #{announce}"
    puts "Length: #{info['length']}"
    puts "Info Hash: #{info_hash}"
    puts "Piece Length: #{info['piece length']}"
    puts "Piece Hashes:"
    # Kinda cheating, but since we want 20 binary char per line and it only takes 2 characters
    # to encode it in hexa, we can put characers 40 per 40
    puts pieces.shift(40).join('') until pieces.empty?
  end
end
