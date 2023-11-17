# frozen_string_literal: true

require 'forwardable'
require 'net/http'

class Torrent
  extend Forwardable

  def_delegators :@torrent, :info, :announce

  def initialize(torrent_hash)
    @torrent = OpenStruct.new(torrent_hash)
  end

  def display_details
    pieces = info['pieces'].bytes.map { _1.to_s(16).rjust(2, '0') }
    info_hash = Digest::SHA1.hexdigest(encoded_info)

    puts "Tracker URL: #{announce}"
    puts "Length: #{info['length']}"
    puts "Info Hash: #{info_hash}"
    puts "Piece Length: #{info['piece length']}"
    puts "Piece Hashes:"
    # Kinda cheating, but since we want 20 binary char per line and it only takes 2 characters
    # to encode it in hexa, we can put characers 40 per 40
    puts pieces.shift(20).join('') until pieces.empty?
  end

  def peers
    state = Bencode::StateManager.build_initial_state(encoded_peers)
    result, = Bencode::Decoder.new(state).call

    result
  end

  private

  def encoded_peers
    uri = URI(announce)
    info_hash = Digest::SHA1.digest(encoded_info)
    params = {
      info_hash: info_hash,
      peer_id: '00112233445566778899',
      port: 6881,
      uploaded: 0,
      downloaded: 0,
      left: info['length'],
      compact: 1
    }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      res.body
    else
      puts res.body
      raise 'failed peer retrieval'
    end
  end

  def encoded_info
    @encoded_info ||= Bencode::Encoder.new(info).call
  end
end
