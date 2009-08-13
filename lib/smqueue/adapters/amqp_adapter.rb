require 'rubygems'
require 'smqueue'
require 'mq'

module SMQueue
  class AmqpAdapter < SMQueue::Adapter
    class Configuration < SMQueue::AdapterConfiguration
      has :queue
    end

    def initialize(*args)
      super
      options = args.first
      @configuration = options[:configuration]
    end

    def put(*args, &block)
      EM.run {
        broker = MQ.new
        broker.queue(@configuration[:queue]).publish(args[0])
        EM.add_timer(0.1) { EM.stop }
      }
    end

    def get(*args, &block)
      if block_given?
        EM.run {
          broker = MQ.new
          broker.queue(@configuration[:queue]).subscribe { |header, body|
            yield ::SMQueue::Message(:headers => header, :body => body)
          }
        }
      else
        @message = nil
        EM.run {
          broker = MQ.new
          broker.queue(@configuration[:queue]).subscribe { |header, body|
            @message = ::SMQueue::Message(:headers => header, :body => body)
            EM.stop
          }
        }
        @message
      end
    end
  end
end