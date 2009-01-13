Gem::Specification.new do |s|
  s.name     = "smqueue"
  s.version  = "0.2.0"
  s.summary  = "Simple Message Queue"
  s.email    = 'http://github.com/seanohalpin/smqueue'
  s.homepage = 'http://github.com/seanohalpin/smqueue'
  s.description = "Implements a simple protocol for using message queues, with adapters
  for ActiveMQ, Spread and stdio (for testing)."
  s.authors  = ["Sean O'Halpin", "Chris O'Sullivan", "Craig Webster"]
  s.files    =
    [
     "History.txt",
     "Manifest.txt",
     "README.txt",
     "Rakefile",
     "examples/input.rb",
     "examples/message_queue.yml",
     "examples/output.rb",
     "lib/rstomp.rb",
     "lib/smqueue.rb",
     "lib/smqueue/adapters/spread.rb",
     "lib/smqueue/adapters/stdio.rb",
     "lib/smqueue/adapters/stomp.rb",
     "smqueue.gemspec",
     "test/helper.rb",
     "test/test_rstomp_connection.rb",
    ]
  s.test_files = ["test/test_rstomp_connection.rb"]
  s.add_dependency("doodle", [">= 0.1.9"])
  s.rubyforge_project = 'smqueue'
end
