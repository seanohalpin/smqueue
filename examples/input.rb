require 'rubygems'
require 'smqueue'
require 'pp'

script_path = File.dirname(__FILE__)
configuration = YAML::load(File.read(File.join(script_path, "config", "example_config.yml")))

if ARGV.size > 0
  queue_name = ARGV[0].to_sym
else
  queue_name = :input
end
input_queue = SMQueue.new(:configuration => configuration[queue_name])

input_queue.get do |msg|
  pp msg
  puts "-" * 40
  puts msg.body
  puts "-" * 40
end
