require 'test_helper'

class TamburPublishTest < Test::Unit::TestCase

  def setup
    url = URI.parse('http://wsbot.tambur.io')
    Net::HTTP::start(url.host, url.port) {|http|
      credentials = JSON.parse(http.get('/credentials').read_body)
      @api_key = credentials['api_key']
      @app_id = credentials['app_id']
      @secret = credentials['secret']
      @subscriber_id = http.get('/subscriber_id').read_body
    }
    @tambur = Tambur::Connector.new(@api_key, @app_id, @secret)
  end

  def test_publish
    publish('test', 'test message')
  end

  def test_auth_publish
    publish('auth:test', 'test message')
  end

  def test_private_publish
    publish('private:'+@subscriber_id, 'test message')
  end

  def publish(stream, msg)
    handle = generate_handle()
    msg = {'handle' => handle, 'msg' => msg}
    json_msg = msg.to_json()
    assert_equal(true, @tambur.publish(stream, json_msg))
    url = URI.parse('http://wsbot.tambur.io')
    Net::HTTP.start(url.host) { | http |
      request = Net::HTTP::Get.new('/results?handle='+handle)
    results = JSON.parse(http.request(request).read_body)
    assert_equal(1, results.length)
    if stream.start_with? 'private'
      assert_equal(results[0][handle], {'private' => msg})
    else
      assert_equal(results[0][handle], {stream => msg})
    end
    }

  end
end

class TamburAuthTokenTest < Test::Unit::TestCase

  def setup
    @tambur = Tambur::Connector.new('30af96de47e3c58329045ff136a4a3ea', 'ws-bot-1', 'wsbot')
  end

  def test_generate_auth_token
    stream = 'auth:test'
    subscriber_id = 'a0629978-28d8-4fd4-b862-f67e9b6dfd8f'
    token = @tambur.generate_auth_token(stream, subscriber_id)
    assert_equal('2f25ad1ce5afab906cc582b6254a912590c60f73', token)
  end

  def test_auth_token_is_optional
    stream = 'valid:stream' # auth streams must start with 'auth:'
    assert_not_nil @tambur.generate_auth_token(stream, 'subscriber_id')

    stream = 'auth:stream'
    assert_not_nil @tambur.generate_auth_token(stream, 'subscriber_id')
  end
end

def generate_handle
  s = ""
  6.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
  return s
end
