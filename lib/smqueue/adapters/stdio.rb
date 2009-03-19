# set of utility adapters for SMQueue
# - StdioLineAdapter: treats each input line as a message
# - StdioAdapter: treats whole of input as a message
# - YamlAdapter: outputs using to_yaml
# - ReadlineAdapter

# TODO: read records from STDIN with configurable record separator (cf. ruby -0)

module SMQueue
  class BaseStdioAdapter < Adapter
    doc "reads STDIN input, creates new Message for each line of input"
    class Configuration < AdapterConfiguration
    end
    def raw_put(*args)
      STDOUT.puts(*args)
    end
    def raw_get
      STDIN.read
    end
    def put(*args, &block)
      raw_put(*args)
    end
    def get(*args, &block)
      while input = raw_get
        msg = SMQueue::Message.new(:body => input)
        if block_given?
          yield(msg)
        end
      end
    end
  end
end

module SMQueue
  class PPAdapter < BaseStdioAdapter
    def raw_put(*args)
      super(args.pretty_inspect)
    end
  end
end

module SMQueue
  class StdioLineAdapter < Adapter
    doc "reads STDIN input, creates new Message for each line of input"
    class Configuration < AdapterConfiguration
    end
    def put(*args, &block)
      STDOUT.puts(*args)
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
    def raw_get
      STDIN.read
    end
    def get(*args, &block)
      input = raw_get
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
    def raw_get(*args, &block)
      YAML::load(STDIN.read)
    end
  end
end

require 'readline'
module SMQueue
  class ReadlineAdapter < StdioLineAdapter
    doc "uses readline to read input from prompt, creates new Message for each line of input"
    has :prompt, :default => "> "
    has :history, :default => true
    def raw_get(*args)
      Readline.readline(prompt, history)
    end
    def get(*args, &block)
      if block_given?
        while input = raw_get
          msg = Message.new(:body => input)
          if block_given?
            yield(msg)
          end
        end
      else
        input = raw_get
        msg = input ? Message.new(:body => input) : nil
      end
      msg
    end
  end
  # life's too short...
  ReadLineAdapter = ReadlineAdapter
end
