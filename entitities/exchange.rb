require "bundler"
Bundler.require :default
require 'date'

AMQP.start do |connection|

  channel  = AMQP::Channel.new(connection)
  exchange = channel.topic("topic.exchange", :auto_delete => true)

  queue = channel.queue("queue.bound.to.exchange").bind(exchange, :routing_key => "routing.key")
    
  queue.subscribe do |payload|
    puts "=> #{payload}"
  end

  exchange.publish("BACKSHOP ROCK  -> #{Time.now}", :routing_key => "routing.key")

end
