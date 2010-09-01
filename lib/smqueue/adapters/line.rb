# LineAdapter

module SMQueue
  class LineAdapter < Adapter
    class Configuration < AdapterConfiguration
      has :filename
      has :delay, :default => 0
      has :read_mode, :default => "r"
      has :write_mode, :default => "a"
    end
    doc "reads file input, creates new Message for each line of input"

    attr_accessor :output_file

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
      @output_file ||= File.open(configuration.filename, configuration.write_mode)
      body, headers = normalize_message(body, headers)
      @output_file.puts body
    end
  end
end

