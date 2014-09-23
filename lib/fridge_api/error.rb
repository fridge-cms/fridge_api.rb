module FridgeApi
  class Error < StandardError

  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when response is a 401 HTTP status code
  class Unauthorized < ClientError; end
end
