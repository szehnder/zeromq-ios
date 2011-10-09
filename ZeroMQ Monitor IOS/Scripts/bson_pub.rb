# usage: ruby pub.rb CHAN USERNAME
#
#     ruby pub.rb rubyonrails technoweenie
#
#
# binds a PUB socket to tcp://*:5555

require 'rubygems'
require 'zmq'
require 'bson'

context = ZMQ::Context.new
chan    = ARGV[0]
user    = ARGV[1]
pub     = context.socket ZMQ::PUB
pub.setsockopt ZMQ::IDENTITY, "#{chan}-#{user}"

pub.bind 'tcp://*:5556'

my_message = {:topic => 'MY_LITTLE_PONY'}

while msg = STDIN.gets
  msg.strip!
  my_message[:body] = "#{msg}"# (#{Time.now})"
  foo = BSON.serialize(my_message).to_s
  header = "#{chan} #{user}"
  puts "Sending header >> #{header}"
  pub.send header, ZMQ::SNDMORE
  pub.send foo
end