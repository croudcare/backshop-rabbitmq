require "bundler"
Bundler.require :default
require 'date'

EventMachine.run do

  AMQP.connect do |connection|

    channel    = AMQP::Channel.new(connection)
    exchange = channel.topic("automatic.topic.ack")
    
 
    3.times do
      to_publish = "Message #{Time.now}"
      puts "Publishing  #{to_publish}"
      exchange.publish(to_publish, :routing_key => 'automatic.key')
    end
    
  end
end