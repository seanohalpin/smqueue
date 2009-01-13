require 'rubygems'
require 'smqueue'
require 'pp'

configuration = YAML::load(File.read("message_queue.yml"))

input_queue = SMQueue.new(:configuration => configuration[:input])

input_queue.get do |msg|
  pp msg
  puts "-" * 40
  puts msg.body
  puts "-" * 40
end
