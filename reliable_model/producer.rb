require "bundler"
Bundler.require :default
require "amqp/extensions/rabbitmq"

EventMachine.run do

  AMQP.connect do |connection|

    channel  = AMQP::Channel.new(connection)
    channel.confirm_select

    channel.on_ack do |basic_ack|
      puts "Message delivered to broker"
    end
    
    exchange = channel.topic("reliable.bus", :durable => true)
    exchange.publish("RELIABLE MESSAGE PERSISTENT", :persistent => true, :routing_key => "reliable.key")
    
    show_stopper = Proc.new do 
      connection.close { EventMachine.stop } 
    end

    Signal.trap "TERM", show_stopper
  end
end