# LineAdapter

require File.join(File.dirname(__FILE__), "stdio.rb")

module SMQueue
  class LineAdapter < Adapter
    class Configuration < AdapterConfiguration
      has :filename
      has :delay, :default => 0
      has :read_mode, :default => "r"
      has :write_mode, :default => "a"
    end
    doc "reads file input, creates new Message for each line of input"

    def get(*args, &block)
      File.open(configuration.filename, configuration.read_mode) do |file|
        while input = file.gets
          msg = SMQueue::Message.new(:body => input)
          yield(msg)
          if configuration.delay > 0
            sleep configuration.delay
          end
        end
      end
    end

    def put(body, headers = { }, &block)
      File.open(configuration.filename, configuration.write_mode) do |file|
        body, headers = normalize_message(body, headers)
        msg = SMQueue::Message.new(:body => body, :headers => headers)
        file.puts msg.to_hash.to_json
      end
    end
  end
end

