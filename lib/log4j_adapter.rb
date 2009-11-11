require 'activesupport'
require File.dirname(__FILE__) + '/log4j-1.2.14.jar'

class Log4jAdapter
  include ActiveSupport::BufferedLogger::Severity
  import org.apache.log4j.Logger
  import org.apache.log4j.Level

  SEVERETIES = {
    DEBUG => Level::DEBUG,
    INFO => Level::INFO,
    WARN => Level::WARN,
    ERROR => Level::ERROR,
    FATAL => Level::FATAL,
  }
  INVERSE = SEVERETIES.invert

  def initialize(adapter_name = ENV['LOG4J_ADAPTER_NAME'])
    raise 'Unrecognized log4j adapter name' unless adapter_name
    
    @logger = Logger.getLogger(adapter_name)
    @root = Logger.getRootLogger
  end

  def add(severity, message = nil, progname = nil, &block)
    raise "Invalid log level" unless SEVERETIES[severity.to_i]
    
    message = (message || (block && block.call) || progname).to_s
    @logger.log(SEVERETIES[severity.to_i], message)
  end

  def level
    INVERSE[@logger.getEffectiveLevel]
  end

  def level=(level)
    raise "Invalid log level" unless SEVERETIES[level.to_i]
    @root.setLevel(SEVERETIES[level.to_i])
  end

  def enabled_for?(severity)
    raise "Invalid log level" unless SEVERETIES[severity.to_i]
    @logger.isEnabledFor(SEVERETIES[severity.to_i])
  end

  #Lifted from BufferedLogger
  for severity in ActiveSupport::BufferedLogger::Severity.constants
    class_eval <<-EOT, __FILE__, __LINE__
      def #{severity.downcase}(message = nil, progname = nil, &block)  # def debug(message = nil, progname = nil, &block)
        add(#{severity}, message, progname, &block)                    #   add(DEBUG, message, progname, &block)
      end                                                              # end
                                                                       #
      def #{severity.downcase}?                                        # def debug?
        enabled_for?(#{severity})                                      #   DEBUG >= @level
      end                                                              # end
    EOT
  end
end