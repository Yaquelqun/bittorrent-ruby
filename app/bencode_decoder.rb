
class BencodeDecoder
  attr_reader :encoded_str

  def initialize(encoded_str)
    @encoded_str = encoded_str
  end

  def call
    case encoded_str[0].chr
    when /\d/
      length = encoded_str.split(':')[0].to_i
      encoded_str.split(':')[1][0, length]
    when 'i'
      encoded_str[1..-2].to_i
    else
      puts "unsupported_format"
      exit(1)
    end
  end
end
