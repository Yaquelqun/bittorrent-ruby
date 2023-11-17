module Helpers
  module BytesFormatter

    # This method turns a binary string such as
    # "\xD6\x9F\x91\xE6\xB2\xAELT$h\xD1\a:q\xD4\xEA\x13\x87\x9A\x7F"
    # into an arrray of hex representation with padded 0 like
    # ["d6", "9f", "91", "e6", "b2", "ae", "4c", "54", "24", "68", "d1", "07", "3a", "71", "d4", "ea", "13", "87", "9a", "7f"]
    def hex_representation(binary_string)
      binary_string.bytes.map { _1.to_s(16).rjust(2, '0') }
    end
  end
end