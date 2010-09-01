# FileTailAdapter
# gem install file-tail
require 'file/tail'

module SMQueue
  class FileTailAdapter < Adapter
    class Configuration < AdapterConfiguration
      has :filename
      has :interval, :default => 0
      has :backward, :default => 0
    end
    doc "tails file, creates new Message for each line of input"

    def get(*args, &block)
      File.open(configuration.filename) do |file|
        file.extend(File::Tail)
        file.interval = self.configuration.interval
        file.backward(self.configuration.backward)
        file.tail do |line|
          msg = SMQueue::Message.new(:body => line)
          yield(msg)
        end
      end
    end
  end
end

