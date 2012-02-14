## Ruby Tambur.io REST API Client
Tambur.io provides a pain-free websocket experience.
###Preliminary
Install this library preferably using [bundler][1]:

    gem "ruby-tambur", :git => "git://github.com/tamburio/ruby-tambur.git", :branch => "master"

Please register on [Tambur.io][2] and create at least one app. This will give you the unique API\_KEY, an APP\_ID and a SECRET, which you need to initialize the client.

###Example
    
    tambur = Tambur::Connector.new(API_KEY, APP_ID, SECRET)
    tambur.publish('mystream', 'some message')
The example above publishes the given message to all subscribed clients. If you want to restrict a stream to just a group of subscribers you can force this using 'authenticated' streams. In such a case the clients must send their SUBSCRIBER_ID's whereas your app must generate an auth-token for any of the subscribers you want to allow to subscribe to the stream.

    tambur.generate_auth_token('auth:mystream', SUBSCRIBER_ID)

this token must be sent back to the client which uses it during the subscription procedure. If you want to further limit your receivers to one specific subscriber you can do this using the 'private' stream.

    tambur.publish('private:'+SUBSCRIBER_ID, 'some private message')


  [1]: http://gembundler.com//
  [2]: http://tambur.io
