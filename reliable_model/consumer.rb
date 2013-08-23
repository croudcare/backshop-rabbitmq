require "bundler"
Bundler.require :default
require 'date'

EventMachine.run do

  AMQP.connect do |connection|

    channel    = AMQP::Channel.new(connection)
    channel.prefetch(1)

    exchange = channel.topic("reliable.bus", :durable => true)
    queue = channel.queue("reliable.queue",  :durable => true).bind(exchange, :routing_key => "reliable.key")
    
    queue.subscribe(:ack => true) do |metadata, payload|
      puts "SUBSCRIBE => #{payload}"
      metadata.ack
    end

  end
end