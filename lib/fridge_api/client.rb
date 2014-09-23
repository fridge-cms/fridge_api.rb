require 'sawyer'
require 'fridge_api/options'
require 'fridge_api/error'

module FridgeApi

  class Client

    include FridgeApi::Options

    def initialize(options = {})
      reset!
      FridgeApi::Options.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || instance_variable_get(:"@#{key}"))
      end
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

    def last_response
      @last_response if defined? @last_response
    end

    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, {}) do |http|
        http.headers[:content_type] = "application/json"
        if !!@access_token
          http.authorization 'token', @access_token
        end
      end
    end

    def reset_agent
      @agent = nil
    end

    def request(method, path, data, options = {})
      @last_response = res = agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      if res.status == 401
        refresh_token!
        return request(method, path, data, options)
      end
      res.data
    end

    def refresh_token!
      res = post("oauth/token", application_authentication)
      if @last_response.status != 200
        raise FridgeApi::Unauthorized
      end
      @access_token = res.access_token
      reset_agent
    end

    private

    def application_authentication
      {
        :grant_type    => "client_credentials",
        :client_id     => @client_id,
        :client_secret => @client_secret
      }
    end
  end
end
