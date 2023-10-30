
module Bencode
  class Decoder
    attr_reader :state, :input

    #takes a state
    def initialize(state)
      @state = state
      @input = state.original_input[state.current_index..]
    end

    # decodes the encoded string
    def call
      result = send("decode_#{state.format}")
      [result, state]
    end

    private

    def decode_string
      str_len, str = input.split(':', 2)
      len = str_len.to_i
      state.current_index += str_len.length + 1 + len
      str[..(len-1)]
    end

    def decode_integer
      result = ""
      counter = 1
      while input[counter] != 'e'
        result += input[counter]
        counter += 1
      end

      state.current_index += counter + 1
      result.to_i
    end

    def decode_list
      result = []
      state.current_index += 1
      while state.original_input[state.current_index] != 'e'
        @state = Bencode::StateManager.update_state(state)
        element, @state = Bencode::Decoder.new(state).call
        result << element
      end

      state.current_index += 1
      result
    end

    def decode_dictionary
      array = decode_list

      result = []
      result << array.shift(2) until array.empty?
      result.to_h
    end
  end
end
