require 'smqueue'
require 'pp'

script_path = File.dirname(__FILE__)
configuration = YAML::load(File.read(File.join(script_path, "..", "config", "message_queue.yml")))

input_name = (ARGV[0] || :readline).to_sym
output_name = (ARGV[1] || :stdio).to_sym

pp [input_name, output_name]

input_queue = SMQueue.new(:configuration => configuration[input_name])
output_queue = SMQueue.new(:configuration => configuration[output_name])

input_queue.get do |msg|
  #p [:start_of_loop]
  data = YAML::load(msg.body)
  pp data
  case data
  when Hash
    msg.body = data["message"].reverse
  when String
    msg.body = data.reverse
  end
  output_queue.put msg.body
  #p [:end_of_loop]
end
