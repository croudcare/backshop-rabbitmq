require "bundler"
Bundler.require :default
require 'date'

AMQP.start do |connection|
  channel  = AMQP::Channel.new(connection)

  # Exchange
  exchange = channel.topic("topic.exchange", :auto_delete => true)
  
  #Binding to QUEUE
  queue = channel.queue("queue.bound.to.exchange").bind(exchange, :routing_key => "routing.key")
  
  #SUBSCRIBE   
  queue.subscribe do |payload|
    puts "=> #{payload}"
  end

  exchange.publish("BACKSHOP ROCK  -> #{Time.now}", :routing_key => "routing.key")

end
