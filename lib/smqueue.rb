# SMQueue
# Simple Message Queue client
# Sean O'Halpin, 2008

# The high-level client API is:
# - SMQueue(config).put msg, headers = {}
# - msg = SMQueue(config).get(headers = {})
# - SMQueue(config).get(headers = {}) do |msg|
#   end
# todo - [X] add :durable option (and fail if no client_id specified)
# todo - [ ] gemify - use Mr Bones
# todo - [ ] change to class (so can be subclassed) - so you're working with an SMQueue instance
# todo - [ ] write protocol (open, close, put, get) in SMQueue (so don't have to do it in adaptors)
# todo - [ ] simplify StompAdapter (get rid of sent_messages stuff)
# todo - [ ] simplify adapter interface
# todo - [ ] sort out libpath

require 'rubygems'
require 'doodle'
require 'doodle/version'
require 'yaml'

class Doodle
  if Doodle::VERSION::STRING < '0.1.9'
    def to_hash
      doodle.attributes.inject({}) {|hash, (name, attribute)| hash[name] = send(name); hash}
    end
    class DoodleAttribute
      has :doc, :kind => String
    end
  end
end

#class SMQueue < Doodle
module SMQueue

  # Mr Bones project skeleton boilerplate
  # :stopdoc:
  VERSION = '0.2.0'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end

  # Utility method used to rquire all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '*', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

  # end Bones boilerplate
  
  class << self
    def dbg(*args, &block)
      if $DEBUG
        if args.size > 0
          STDERR.print "SMQUEUE.DBG: "
          STDERR.puts(*args)
        end
        if block_given?
          STDERR.print "SMQUEUE.DBG: "
          STDERR.puts(block.call)
        end
      end
    end

    # JMS expiry time in milliseconds from now
    def calc_expiry_time(seconds = 86400 * 7) # one week
      ((Time.now.utc + seconds).to_f * 1000).to_i
    end
    
    # resolve a string representing a classname
    def const_resolve(constant)
      constant.to_s.split(/::/).reject{|x| x.empty?}.inject(self) { |prev, this| prev.const_get(this) }
    end
  end

  class AdapterConfiguration < Doodle
    has :logger, :default => nil

    # need to use custom to_yaml because YAML won't serialize classes
    def to_hash
      doodle.attributes.inject({}) {|hash, (name, attribute)| hash[name] = send(name); hash}
    end
    def to_yaml(*opts)
      to_hash.to_yaml(*opts)
    end
    def initialize(*args, &block)
      #p [self.class, :initialize, args, caller]
      super
    end
    has :adapter_class, :kind => Class do
      from String, Symbol do |s|
        SMQueue.const_resolve(s.to_s)
      end
      # Note: use closure so this is not evaluated until after NullAdapter class has been defined
      default { NullAdapter }
    end
    has :configuration_class, :kind => Class do
      init { adapter_class::Configuration }
      from String do |s|
        #Doodle::Utils.const_resolve(s)
        SMQueue.const_resolve(s.to_s)
      end
    end
  end

  class Adapter < Doodle
    has :configuration, :kind => AdapterConfiguration, :abstract => true do
      from Hash do |h|
        #p [:Adapter, :configuration_from_hash]
        Doodle.context.last.class::Configuration.new(h)
      end
      from Object do |h|
        #p [:Adapter, :configuration_from_object, h.inspect, h.class]
        h
      end
    end
    # these are not called anywhere...
    def open(*args, &block)
    end
    def close(*args, &block)
    end
    # these are the core methods
    def get(*args, &block)
    end
    def put(*args, &block)
    end
    def self.create(configuration)
      # FIXME: dup config, otherwise can use it only once - prob. better way to do this
      configuration = configuration.dup
      adapter = configuration.delete(:adapter)
      #p [:adapter, adapter]
      ac = AdapterConfiguration.new(:adapter_class => adapter)
      #p [:ac, ac]
      klass = ac.adapter_class
      #p [:class, klass]
      #puts [:configuration, configuration].pretty_inspect
#      klass.new(:configuration => configuration)
      klass.new(:configuration => configuration)
    end
  end

  class NullAdapter < Adapter
    class Configuration < AdapterConfiguration
    end
  end

  class Message < Doodle
    has :headers, :default => { }
    has :body
  end
  
  class << self
    def new(*args, &block)
      a = args.first
      if a.kind_of?(Hash) && a.key?(:configuration)
        args = [a[:configuration]]
      end
      Adapter.create(*args, &block)
    end
  end

end
def SMQueue(*args, &block)
 SMQueue.new(*args, &block)
end

# SMQueue.require_all_libs_relative_to(__FILE__)

# require adapters relative to invocation path first, then from lib
[$0, __FILE__].each do |path|
  base_path = File.expand_path(File.dirname(path))
  adapter_path = File.join(base_path, 'smqueue', 'adapters', '*.rb')
  Dir[adapter_path].each do |file|
    require file
  end
end

if __FILE__ == $0
  yaml = %[
:adapter: :StompAdapter
:host: localhost
:port: 61613
:name: /topic/smput.test
:reliable: true
:reconnect_delay: 5
:subscription_name: test_stomp
:client_id: hello_from_stomp_adapter
:durable: false
]

  adapter = SMQueue(:configuration => YAML.load(yaml))
  adapter.get do |msg|
    puts msg.body
  end

end

