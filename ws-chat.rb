require 'em-websocket'

#
# broadcast all ruby related tweets to all connected users!
#

EventMachine.run {
  @channel = EM::Channel.new

  # @channel.push "#{status['user']['screen_name']}: #{status['text']}"
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|

    ws.onopen {
      sid = @channel.subscribe { |msg| ws.send msg }
      @channel.push "#{sid} connected!"

      ws.onmessage { |msg|
        @channel.push "<#{sid}>: #{msg}"
      }

      ws.onclose {
        @channel.unsubscribe(sid)
      }
    }

  end

  puts "Server started"
}
