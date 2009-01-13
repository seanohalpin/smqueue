require 'rubygems'
require 'smqueue'

configuration = YAML::load(File.read("message_queue.yml"))

input_queue = SMQueue.new(:configuration => configuration[:readline])
output_queue = SMQueue.new(:configuration => configuration[:output])

input_queue.get do |msg|
  output_queue.put msg.body
end
