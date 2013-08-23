require "bundler"
Bundler.require :default

EventMachine.run do

  AMQP.connect do |connection|

    channel  = AMQP::Channel.new(connection)
    exchange = channel.topic("linkedcare.bus", :durable => true)
    
    exchange.publish("new patient uuid", :persistent => true, :routing_key => "patient.uuid")
    
    show_stopper = Proc.new do 
      connection.close { EventMachine.stop } 
    end

    Signal.trap "TERM", show_stopper
  end
end