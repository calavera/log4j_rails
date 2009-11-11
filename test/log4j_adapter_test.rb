require File.dirname(__FILE__) + '/../lib/log4j_adapter'
require 'test/unit'

class Log4jAdapterTest < Test::Unit::TestCase
  
  def test_initialize_raises_error_when_adapter_name_nil
    ENV['LOG4J_ADAPTER_NAME'] = nil
    assert_raise(RuntimeError) { Log4jAdapter.new }
  end
  
  def test_initialize_nothing_raised
    ENV['LOG4J_ADAPTER_NAME'] = 'test.log4j'
    assert_nothing_raised { Log4jAdapter.new }
  end
  
  def test_level_eq_raises_error
    assert_raise(RuntimeError) { adapter.level = 20 }
  end
  
  def test_level_eq_returns_level
    assert_equal Log4jAdapter::INVERSE[Log4jAdapter::Level::FATAL], adapter.level = 4
  end
  
  def test_debug_as_default_level
    assert_equal Log4jAdapter::INVERSE[Log4jAdapter::Level::DEBUG], adapter.level
  end
  
  def test_root_level_as_logger_level
    adapter.level = 4
    assert_equal Log4jAdapter::INVERSE[Log4jAdapter::Level::FATAL], adapter.level
  end
  
  def test_enable_for_every_log_level_on_default
    Log4jAdapter::SEVERETIES.keys.each do |k|
      assert adapter.enabled_for?(k)
    end
  end
  
  def test_add_raises_error_on_invalid_severity
    assert_raise(RuntimeError) { adapter.add(10) }
  end
  
  def test_add_logs_nothing_when_no_message_or_block_or_progname
    assert_nothing_raised { adapter.add(4) }
  end
  
  def adapter
    ENV['LOG4J_ADAPTER_NAME'] = 'test.log4j'
    @adapter ||= Log4jAdapter.new 
  end
end