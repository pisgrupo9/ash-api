module Helpers
  # Helper method to parse a response
  #
  # @param [ActionController::TestResponse] response
  # @return [Hash]
  def parse_response(response)
    JSON.parse(response.body)
  end
end
