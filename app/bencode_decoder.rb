
class BencodeDecoder
  attr_reader :encoded_str

  def initialize(encoded_str)
    @encoded_str = encoded_str
  end

  def call
    send("decode_#{format(encoded_str)}", encoded_str)
  end

  private

  def format(input)
    case input[0].chr
    when /\d/
      :string
    when 'i'
      :integer
    when 'l'
      :list
    else
      puts "unsupported_format"
      exit(1)
    end
  end

  def decode_string(input)
    length = input.split(':')[0].to_i
    input.split(':')[1][0, length]
  end

  def decode_integer(input)
    input[1..-2].to_i
  end
end
