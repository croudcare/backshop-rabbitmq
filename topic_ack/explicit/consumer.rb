require "bundler"
Bundler.require :default
require 'date'

EventMachine.run do

  AMQP.connect do |connection|

    channel    = AMQP::Channel.new(connection)
    channel.prefetch(1)

    exchange = channel.topic("explicit.topic.ack")
    queue = channel.queue("explicit.ack", :durable => true).bind(exchange, :routing_key => "explicit.key")

    queue.subscribe(:ack => true) do |metadata, payload|
      puts "payload => #{payload}"
      metadata.ack
    end

  end
end