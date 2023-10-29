
class BencodeDecoder
  attr_reader :encoded_str

  #takes an encoded string as input
  def initialize(encoded_str)
    @encoded_str = encoded_str
  end

  # decodes the encoded string
  def call
    send("decode_#{format(encoded_str)}", encoded_str)
  end

  private

  # returns the format of the first element in the input
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

  ### STRING ###

  # returns a decoded string if the first element of the input is a string
  def decode_string(input)
    string_length = input.split(':')[0].to_i
    input.split(':')[1..].join(':')[0, string_length]
  end

  # returns the length of the first encoded element if it is a string
  def encoded_string_length(input)
    length = input.split(':')[0].to_i
    input.split(':')[0].length + 1 + length
  end

  ### Integer ###

  # returns a decoded string if the first element of the input is an integer
  def decode_integer(input)
    input[1..-2].to_i
  end

  # returns the length of the first encoded element if it is an integer
  def encoded_integer_length(input)
    input.match(/(i[-\d]*e)/)[1].length
  end

  ### List ###

  # returns a decoded array if the first element of the input is a list
  def decode_list(input)
    to_be_decoded = input[1..-2]
    result = []

    until to_be_decoded.empty?
      current_format = format(to_be_decoded)
      current_element_length = send("encoded_#{current_format}_length", to_be_decoded)

      result << send("decode_#{current_format}", to_be_decoded)
      to_be_decoded = to_be_decoded[current_element_length..]
    end

    result
  end

  # returns the length of the first encoded element if it is a list
  def encoded_list_length(input)
    input.match(/(l.*e)/)[1].length
  end

  ### Dictionary ###

  # returns a decoded array if the first element of the input is a dictionnary
  def decode_dictionary(input)
    array_version = decode_list(input)
    dictionnary = []
    # fun Ruby fact, you can turn an array of arrays that each have 2 elements into a hash by calling .to_h
    # so decoding a dictionary is very basically decoding a list with extra steps
    dictionnary << array_version.shift(2) until array_version.empty?
    dictionnary.to_h
  end

  # returns the length of the first encoded element if it is a dictionnary
  def encoded_dictionary_length(input)
    input.match(/(d.*e)/)[1].length
  end
end
