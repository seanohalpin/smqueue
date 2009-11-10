require 'rubygems'
require 'smqueue'

script_path = File.dirname(__FILE__)
configuration = YAML::load(File.read(File.join(script_path, "config", "example_config.yml")))

if ARGV.size > 0
  input_queue_name = ARGV[0].to_sym
  output_queue_name = ARGV[1].to_sym
else
  input_queue_name = :readline
  output_queue_name = :output
end
input_queue = SMQueue.new(:configuration => configuration[input_queue_name])
output_queue = SMQueue.new(:configuration => configuration[output_queue_name])

input_queue.get do |msg|
  output_queue.put msg.body
end
