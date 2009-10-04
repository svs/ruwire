require 'jackaudio'
require 'yaml'
class Ruwire
  attr_accessor :jack

  def initialize
    @jack = Jackaudio::BlockingAudioIO.new("ruwire",2,2)    
    @jack.start
  end

  def getAllPortNames
    @jack.getAllPortNames
  end
  
  def disconnectAll
    ports = @jack.getAllPortNames
    ports.each do |port|
      c = @jack.getPortConnections(port)
      c.each do |_c|
        @jack.disconnectPorts(port,_c)
      end
    end
  end

  def disconnect(port1, port2)
    @jack.disconnectPorts(port1, port2)
  end

  def connect(port1, port2)
    @jack.connectPorts(port1,port2)
  end

  def clientExists?(clientName)
    @jack.getAllPortNames.select{|p| p =~ /#{clientName}/}.size > 0
  end

  def load(fileName)
    y = YAML.parse(File.read("#{fileName}.yml"))
    required = y.select('required')[0]
    required.children.each do |c|
      puts "checking for #{c.value}"
      if  not clientExists?(c.value)
        puts "not found....running #{c.value}"
        exec "#{c.value}" if fork.nil?
      end
    end
    puts "waiting for all clients to connect"
    all_connected = false
    while (all_connected != true) do
      sleep(3)
      all_connected = true
      required.children.each do |c|
        if not clientExists?(c.value)
          puts "waiting for #{c.value}"
          all_connected = false
        end
      end
    end
    puts "making appropriate connections"
    disconnectAll
    connections = y.select('connections')[0]
    connections.value.keys.each do |k|
      puts "connecting #{k.value} to #{connections.value[k].value}"
      connect(k.value,connections.value[k].value)
    end
  end
end

