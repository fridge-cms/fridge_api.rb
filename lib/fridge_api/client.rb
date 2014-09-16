require 'sawyer'

module FridgeApi

  class Client

    def initialize(options = {})

    end

    def get(url, options = {})
      request :get, url, options
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def delete(url, options = {})
      request :delete, url, options
    end

    def agent
      @agent ||= Sawyer::Agent.new() do |http|
        http.header[:content_type] = "application/json"
        # pass in auth
        # http.authorization 'token', @access_token
        # http.params = http.params.merge application_authentication
      end
    end

    def request(method, path, data, options = {})
      @last_response = response = agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      response.data
    end
  end
end
