require 'rubygems'
require 'smqueue'

script_path = File.dirname(__FILE__)
configuration = YAML::load(File.read(File.join(script_path, "config", "example_config.yml")))

input_queue = SMQueue.new(:configuration => configuration[:readline])
output_queue = SMQueue.new(:configuration => configuration[:output])

input_queue.get do |msg|
  output_queue.put msg.body
end
