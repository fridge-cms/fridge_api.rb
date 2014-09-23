module FridgeApi
  module Options

    DEFAULTS = {
      :api_endpoint => "http://api.fridgecms.com/v1"
    }

    attr_accessor :access_token, :client_id, :client_secret

    class << self
      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :client_id,
          :client_secret
        ]
      end
    end

    def configure
      yield self
    end

    def reset!
      FridgeApi::Options.keys.each do |key|
        instance_variable_set(:"@#{key}", DEFAULTS[key] || nil)
      end
    end

    def api_endpoint
      File.join(@api_endpoint, "")
    end

  end
end
