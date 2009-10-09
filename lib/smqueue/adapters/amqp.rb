require 'mq'
require 'pp'

module SMQueue
  class AMQPAdapter < Adapter
    module EventMachine
      def self.safe_run(background = nil, &block)
        if ::EM::reactor_running?
          # Attention: here we loose the ability to catch
          # immediate connection errors.
          ::EM::next_tick(&block)
          sleep unless background # this blocks the thread as it was inside a reactor
        else
          if background
            @@em_reactor_thread = Thread.new do
              ::EM::run(&block)
            end
          else
            ::EM::run(&block)
          end
        end
      end
    end

    class Configuration < AdapterConfiguration
      has :host, :kind => String, :default => "localhost" do
        doc <<-EDOC
          The host that runs the broker you want to connect to.
        EDOC
      end
      has :port, :kind => Integer, :default => 5673 do
        doc <<-EDOC
          The port that your message broker is accepting connections on.
        EDOC
      end
      has :name, :kind => String, :default => "", :doc => "name of queue to connect to"
      has :logfile, :default => STDERR do
        doc <<-EDOC
          Where should we log to. Default is STDERR.
        EDOC
      end
      has :logger, :default => nil do
        doc <<-EDOC
          A logger that's to log with. If this is left out of the options a
          new Logger is built that talks to the logfile.
        EDOC
      end #'
      has :user, :default => "guest"
      has :password, :default => "guest"
    end
    has :connection, :default => nil

    # handle an error
    def handle_error(exception_class, error_message, caller)
      #configuration.logger.warn error_message
      raise exception_class, error_message, caller
    end

    # connect to message broker
    def connect(*args, &block)
      AMQP.start(
                 :host => configuration.host,
                 #:port => configuration.port,
                 :user => configuration.user,
                 :password => configuration.password
                 )
      self.connection ||= MQ.new
    end

    # get message from queue
    def get(headers = {}, &block)
      message = nil
      EventMachine.safe_run do
        connect
        q = connection.queue(configuration.name)
        if block
          SMQueue.dbg { "entering loop get" }
          q.subscribe do |msg|
            SMQueue.dbg { [:get, :loop, :msg, msg].inspect }
            message = SMQueue::Message.new(:body => msg)
            block.call(message)
          end
        else
          SMQueue.dbg { "singleshot get" }
          q.subscribe do |msg|
            message = SMQueue::Message.new(:body => msg)
            SMQueue.dbg { [:get, :singleshot, :msg, msg].inspect }
            q.unsubscribe
            ::EM.stop
          end
        end
        SMQueue.dbg { [:smqueue, :get, headers].inspect }
      end
      message
    end

    # put a message on the queue
    def put(body, headers = { })
      SMQueue.dbg { [:smqueue, :put, body, headers].inspect }
      EventMachine.safe_run(true) do
        SMQueue.dbg { [:smqueue, :put, :connecting].inspect }
        self.connect
        SMQueue.dbg { [:smqueue, :put, :publishing].inspect }
        q = connection.queue(configuration.name)
        SMQueue.dbg { [:smqueue, :put, :after_publishing, q].pretty_inspect }
        q.publish(body)
      end
      SMQueue.dbg { [:num_threads, Thread.list.size].inspect }
    end
  end
end
