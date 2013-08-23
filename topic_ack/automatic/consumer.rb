require "bundler"
Bundler.require :default
require 'date'

EventMachine.run do

  AMQP.connect do |connection|

    channel    = AMQP::Channel.new(connection)
    channel.prefetch(1)

    exchange = channel.topic("automatic.topic.ack")
    queue = channel.queue("automatic.ack", :durable => true).bind(exchange, :routing_key => "automatic.key")

    queue.subscribe do |metadata, payload|
      puts "payload => #{payload}"
    end

  end
end