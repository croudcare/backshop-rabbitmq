require "bundler"
Bundler.require :default
require 'date'

AMQP.start do |connection|
  channel    = AMQP::Channel.new(connection)
  channel.prefetch(1)

  exchange = channel.topic("explicit.topic.ack")

  3.times do
    to_publish = "Message #{Time.now}"
    puts "Publishing  #{to_publish}"
    exchange.publish(to_publish, :routing_key => "explicit.key")
  end
end