
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
      Bencode::StateManager.update_state(state)
      [result, state]
    end

    private

    ### STRING ###

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
  end
end
