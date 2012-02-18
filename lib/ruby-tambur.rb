require "ruby-tambur/version"
require "ruby-tambur/vendor/oauth_util.rb"
require 'net/http'
require 'openssl'

module Tambur
    class Connector
        def initialize(api_key, app_id, secret, options = {})
            @app_id = app_id
            @api_host = options[:api_host] || 'api.tambur.io'
            @oauth = Tambur::Util::OAuth.new()
            @oauth.consumer_key=api_key
            @oauth.consumer_secret=secret
            @oauth.req_method='POST'
        end

        def publish(stream, message)
            path = '/app/' + @app_id + '/stream/' + stream.to_str+'?api_version=1.0&message='+ CGI::escape(message)
            url = URI.parse('http://' + @api_host + path)
            Net::HTTP.start(url.host) { | http |
                request = Net::HTTP::Post.new(url.path)
            request.body = @oauth.sign(url).query_string()
            request['Content-Type'] = 'application/x-www-form-urlencoded'
            response = http.request(request)
            if response.code == '204'
                return true
            else
                raise 'publish error: '+response.read_body
            end
            }
        end

    def generate_auth_token(stream, subscriber_id)
      stream.insert(0,"auth:") unless stream.start_with? "auth:"
      auth_string = @oauth.consumer_key + ':' + @app_id + ':' + stream + ':' + subscriber_id
      digest = OpenSSL::Digest::Digest.new( 'sha1' )
      return OpenSSL::HMAC.hexdigest( digest, @oauth.consumer_secret, auth_string)
    end
  end
end
