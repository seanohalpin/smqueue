#
# logging utils
#
# provides global logger method to access the global @logger object
#
# requires BASE_PATH to be set
#
require 'rubygems'
require 'logging'

module LogUtil
  class << self
    
    def create_logfile(basename = File.basename($0, '.rb'), filename = File.join(BASE_PATH, 'log', "#{basename}.log"), level = :info)
      #p [:create_logfile, basename, filename, level]
      @logger = Logging::Logger[basename]
      file_layout = Logging::Layouts::Pattern.new(
                                             :pattern => "[%d] %c - %-5l : %m\n",
                                             :date_pattern => "%Y-%m-%d %H:%M:%S.%s"
                                             )
      @logger.add_appenders(
                            Logging::Appenders::RollingFile.new(filename,
                                                                :layout => file_layout,
                                                                :truncate => true,
                                                                :size => 1024 * 1024 * 10, # 10 Meg
                                                                :keep => 2,
                                                                :safe => true)
                            )
 
      # Log everything to stdout too
      stdout_layout = Logging::Layouts::Pattern.new( :pattern => "%c - %-5l : %m\n" )
      @logger.add_appenders( Logging::Appenders::Stdout.new( :layout => stdout_layout ) )
                            
      #pp [:appenders, @logger.instance_eval {  @appenders }]
      #p [:level, @logger.level]
      @logger.level = level
      #p [:level, @logger.level]
      @logger
    end

    def logger
      @logger ||= create_logfile
    end
  end
end

def logger
  LogUtil.logger
end

if $0 == __FILE__
  BASE_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  logger.info "Hello World!"
end
