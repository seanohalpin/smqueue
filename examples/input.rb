require 'rubygems'
require 'smqueue'
require 'pp'

script_path = File.dirname(__FILE__)
configuration = YAML::load(File.read(File.join(script_path, "config", "example_config.yml")))

input_queue = SMQueue.new(:configuration => configuration[:input])

p input_queue.get

input_queue.get do |msg|
  pp msg
  puts "-" * 40
  puts msg.body
  puts "-" * 40
end
