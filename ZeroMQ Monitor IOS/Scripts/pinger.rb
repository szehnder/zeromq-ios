require 'zmq'
context = ZMQ::Context.new
pub = context.socket ZMQ::PUB
pub.setsockopt ZMQ::IDENTITY, 'ping-pinger'
pub.bind 'tcp://*:5555'

i=0
loop do
  pub.send "ping pinger #{i+=1}" ; sleep 1
end
