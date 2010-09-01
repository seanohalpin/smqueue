require 'smqueue'

config = {
  :adapter => :FileTail,
  :filename => ARGV[0] || "/var/log/syslog",
  :backward => 0,
}

input_queue = SMQueue.new(:configuration => config)
input_queue.get do |msg|
  puts msg.body
  puts "-" * 40
end
