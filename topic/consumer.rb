
require "bundler"
Bundler.require :default
 
EventMachine.run do

  AMQP.connect do |connection|

    channel  = AMQP::Channel.new(connection)
    
    exchange = channel.topic("linkedcare.bus", :durable => true)
 
    queue = channel.queue("mylinkedcare.patient.uuid", :durable => true).bind(exchange, :routing_key => "patient.uuid")
    
    queue.subscribe do |metadata, payload|
      puts "DATA => #{payload}"
      puts "METADATA => #{metadata.inspect}"

    end
 
    show_stopper = Proc.new { connection.close { EventMachine.stop } }
    Signal.trap "TERM", show_stopper
 
  end

end