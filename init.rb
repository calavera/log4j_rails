if RUBY_PLATFORM =~ /java/
  require 'lib/log4j_adapter'
  Rails.logger = Log4jAdapter.new
end