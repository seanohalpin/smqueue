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
      @client_thread = nil
    end

    def put(*args, &block)
      connect
      channel.publish(args[0])
    end

    def get(*args, &block)
      if block_given?
        EM.run {
          channel.subscribe { |header, body|
            yield ::SMQueue::Message(:headers => header, :body => body)
          }
        }
      else
        raise "TODO: Implement me"
      end
    end

    private
    def connect
      current_thread = Thread.current
      @client_thread ||= Thread.new {
        AMQP.start {
          current_thread.wakeup
        }
      }
    end

    def channel
      MQ.queue(@configuration[:queue])
    end
  end
end