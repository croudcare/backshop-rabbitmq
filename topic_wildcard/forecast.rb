require "bundler"
Bundler.require :default
 
EventMachine.run do

  AMQP.connect do |connection|
    channel  = AMQP::Channel.new(connection)
    exchange = channel.topic("pub/sub", :auto_delete => true)

    channel.queue("meteo.lisboa").bind(exchange, :routing_key => "meteo.pt.lisboa.#").subscribe do |metadata, payload|
      puts "-"*20
      puts " NEW FORECAST: LISBOA "
      puts  payload
      puts "-"*20
    end

    channel.queue("meteo.porto").bind(exchange, :routing_key => "meteo.pt.porto.#").subscribe do |metadata, payload|
      puts "-"*20
      puts " NEW FORECAST: PORTO "
      puts  payload
      puts "-"*20    
    end

    channel.queue("meteo.portugal").bind(exchange, :routing_key => 'meteo.pt.#').subscribe do |metadata, payload| 
      puts "-"*20
      puts " NEW FORECAST: PORTUGAL "
      puts  payload
      puts "-"*20
    end

    
    
    # publish updates 1 second later, after all queues are declared and bound
    EventMachine.add_timer(1) do

       exchange.publish("SUMMER LISBON: 30 C", :routing_key => "meteo.pt.lisboa.summer")
       exchange.publish("WINTER LISBON: 10 C", :routing_key => "meteo.pt.lisboa.winter")
       exchange.publish("FALL LISBON:   16 C", :routing_key => "meteo.pt.lisboa.fall")
       exchange.publish("SPRING LISBON: 15 C", :routing_key => "meteo.pt.lisboa.spring")


       exchange.publish("SUMMER PORTO: 25 C", :routing_key => "meteo.pt.porto.summer")
       exchange.publish("WINTER PORTO: 7 C", :routing_key => "meteo.pt.porto.winter")
       exchange.publish("FALL PORTO:   12 C", :routing_key => "meteo.pt.porto.fall")
       exchange.publish("SPRING PORTO: 10 C", :routing_key => "meteo.pt.porto.spring")

    end

    show_stopper = Proc.new { connection.close { EventMachine.stop } }

    Signal.trap "TERM", show_stopper
    EM.add_timer(3, show_stopper)
  end
end