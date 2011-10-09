# usage: ruby sub.rb
#
# Connects a SUB socket to tcp://*:5555.
# Subscribes to rubyonrails and ruby-lang.

require 'rubygems'
require 'zmq'
require 'bson'

class Subscriber
  attr_reader :id, :socket
  def initialize(id = nil)
    @id = id || rand.to_s
  end

  def connect(*addrs)
    if !@socket
      context = addrs.shift
      @socket = context.socket ZMQ::SUB
      @socket.setsockopt ZMQ::IDENTITY, @id
    end

    addrs.each do |addr|
      @socket.connect addr
    end
  end

  def subscribe_to(*channels)
    channels.each { |ch| @socket.setsockopt ZMQ::SUBSCRIBE, ch }
  end

  def process(line = nil)
    line ||= @socket.recv
    
    if (@socket.getsockopt(ZMQ::RCVMORE))
      puts "Line: #{line}"
      chan, user = line.split ' ', 2
      puts "Chan: #{chan}"
      puts "User: #{user}"
    else
      puts " <-- MESSAGE RECEIVED --> "
      my_hash = BSON.deserialize(line.unpack("C*"))
      puts "My Hash: #{my_hash}"
    end

    
    # chan, user, msg = line.split ' ', 3
    # puts msg
    # p_msg.parse_from_string(msg)
    # puts "MSG: #{msg.to_s}"
  
  # temp = Com::Foo::ChatMessage.new
  # temp.topic = "my_topic"
  # temp.body = "this is the body"
  # s_temp = temp.serialize_to_string
  # puts "Serialized test string: #{s_temp}"

    # p_msg.parse_from_string(s_temp)
    #     puts "[#{p_msg.topic}] #{p_msg.body}"
    
    # puts "##{chan} [#{user}]: #{msg}"
    true
  rescue SignalException
    process(line) if line
    false
  end

  def close
    @socket.close
    @socket = nil
  end
end

subscriber = Subscriber.new ARGV[0]
subscriber.connect ZMQ::Context.new, 'tcp://127.0.0.1:5556'
subscriber.subscribe_to 'rubyonrails', 'ruby-lang', 'ping', 'NASDAQ'

loop do
  unless subscriber.process
    subscriber.close
    puts "Quitting..."
    exit
  end
end
