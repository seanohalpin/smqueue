require 'test/unit'
require 'smqueue'
require 'rstomp'
require 'mocha'

class TestRStompConnection < Test::Unit::TestCase

  # Tests to see if when a primary queue falls over whether it rollsover to use the secondary.
  def test_if_primary_queue_fails_rollover_to_secondary
    TCPSocket.expects(:open).with("localhost", 61613).raises RStomp::RStompException
    TCPSocket.expects(:open).with("secondary", 1234).returns true
    
    stub_connection_calls_to_queue
    connection = RStomp::Connection.new(YAML.load(configuration))
  end
  
  # Tests to see if when a primary queue falls over whether it rollsover to use the secondary even for unreliable queues.
  def test_if_primary_queue_fails_rollover_to_secondary_with_unreliable_queue
    TCPSocket.expects(:open).with("localhost", 61613).raises RStomp::RStompException
    TCPSocket.expects(:open).with("secondary", 1234).returns true

    stub_connection_calls_to_queue
    connection = RStomp::Connection.new(YAML.load(configuration).merge(:reliable => false))
  end

  
private

  def configuration
      yaml = %[
    :adapter: :StompAdapter
    :host: localhost
    :port: 61613
    :secondary_host: secondary
    :secondary_port: 1234
    :name: /topic/smput.test
    :reliable: true
    :reconnect_delay: 5
    :subscription_name: test_stomp
    :client_id: hello_from_stomp_adapter
    :durable: false
    ]
  end
  
  def stub_connection_calls_to_queue
    RStomp::Connection.any_instance.stubs(:_transmit).returns true
    RStomp::Connection.any_instance.stubs(:_receive).returns true
    RStomp::Connection.any_instance.stubs(:sleep)    
  end
  
end