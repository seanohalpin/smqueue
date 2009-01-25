# set of utility adapters for SMQueue

module SMQueue
  class StdioLineAdapter < Adapter
    doc "reads STDIN input, creates new Message for each line of input"
    class Configuration < AdapterConfiguration
    end
    def put(*args, &block)
      STDOUT.puts *args
    end
    def get(*args, &block)
      while input = STDIN.gets
        msg = SMQueue::Message.new(:body => input)
        if block_given?
          yield(msg)
        end
      end
    end
  end
end

module SMQueue
  class StdioAdapter < StdioLineAdapter
    doc "reads complete STDIN input, creates one shot Message with :body => input"
    def get(*args, &block)
      input = STDIN.read
      msg = SMQueue::Message.new(:body => input)
      if block_given?
        yield(msg)
      end
    end
  end
end

module SMQueue
  class YamlAdapter < StdioAdapter
    doc "outputs message as YAML"
    def put(*args)
      STDOUT.puts args.to_yaml
    end
  end
end

require 'readline'
module SMQueue
  class ReadlineAdapter < StdioLineAdapter
    doc "uses readline to read input from prompt, creates new Message for each line of input"
    has :prompt, :default => "> "
    has :history, :default => true
    def get(*args, &block)
      while input = Readline.readline(prompt, history)
        msg = Message.new(:body => input)
        if block_given?
          yield(msg)
        end
      end
    end
  end
  ReadLineAdapter = ReadlineAdapter
end
