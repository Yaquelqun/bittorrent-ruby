# frozen_string_literal: true

module Bencode
  module StateManager
    extend self

    def build_initial_state(input)
      state = OpenStruct.new
      state.original_input = input
      state.current_index = 0
      state.format = FormatFinder.encoded_format(input)
      state
    end

    def update_state(state)
      return state if state.current_index == state.original_input.length

      state.format = FormatFinder.encoded_format(state.original_input[state.current_index..])
      state
    end
  end
end
