# usage: ruby pub.rb CHAN USERNAME
#
#     ruby pub.rb rubyonrails technoweenie
#
#
# binds a PUB socket to tcp://*:5555

require 'rubygems'
require 'zmq'
require './chat_message.pb.rb'

context = ZMQ::Context.new
chan    = ARGV[0]
user    = ARGV[1]
pub     = context.socket ZMQ::PUB
pub.setsockopt ZMQ::IDENTITY, "#{chan}-#{user}"

pub.bind 'tcp://*:5555'

my_message = Com::Foo::ChatMessage.new
my_message.topic = "MY_LITTLE_PONY"

while msg = STDIN.gets
  msg.strip!
  my_message.body = "#{msg}"# (#{Time.now})"
  foo = my_message.serialize_to_string
  header = "#{chan} #{user}"
  puts "Sender header >> #{header}"
  pub.send header, ZMQ::SNDMORE
  # puts "Sending msg >> #{foo}"
  pub.send "foo"
end