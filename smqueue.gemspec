# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{smqueue}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sean O'Halpin", "Chris O'Sullivan", "Craig Webster"]
  s.date = %q{2010-04-01}
  s.default_executable = %q{mqp}
  s.description = %q{Implements a simple protocol for using message queues, with adapters for STOMP (ActiveMQ), AMQP, XMPP PubSub, HTTP, Spread and stdio (for testing).}
  s.email = %q{seanohalpin@gmail.com}
  s.executables = ["smq"]
  s.extra_rdoc_files = [
    "History.txt",
     "Manifest.txt",
     "README.rdoc"
  ]
  s.files = [
    "History.txt",
     "Manifest.txt",
     "Rakefile",
     "examples/config/example_config.yml",
     "examples/input.rb",
     "examples/output.rb",
     "lib/rstomp.rb",
     "lib/smqueue.rb",
     "lib/smqueue/adapters/amqp.rb",
     "lib/smqueue/adapters/bunny.rb",
     "lib/smqueue/adapters/http_server.rb",
     "lib/smqueue/adapters/spread.rb",
     "lib/smqueue/adapters/stdio.rb",
     "lib/smqueue/adapters/stomp.rb",
     "lib/smqueue/adapters/thread_queue.rb",
     "lib/smqueue/adapters/xmpp_pub_sub.rb",
     "lib/smqueue/adapters/file_tail.rb",
     "smqueue.gemspec",
     "test/helper.rb",
     "test/test_rstomp_connection.rb"
  ]
  s.homepage = %q{http://github.com/seanohalpin/smqueue}
  s.rdoc_options = ["--charset=UTF-8 --line-numbers", "--inline-source", "--title", "Doodle", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{smqueue}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Simple Message Queue}
  s.test_files = [
    "test/test_rstomp_connection.rb"
  ]

  s.add_dependency(%q<doodle>, [">= 0.1.9"])
end

