require 'smqueue'

if ARGV.size > 0
  input_queue_name = ARGV[0].to_sym
  output_queue_name = ARGV[1].to_sym
else
  input_queue_name = :readline
  output_queue_name = :output
end

input_queue = SMQueue.new(input_queue_name)
output_queue = SMQueue.new(output_queue_name)

input_queue.get do |msg|
  output_queue.put msg.body
end
