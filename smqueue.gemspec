require 'smqueue'

Gem::Specification.new do |s|
  s.name     = "smqueue"
  s.version  = SMQueue::VERSION
  s.summary  = "Simple Message Queue"
  s.email    = 'http://github.com/seanohalpin/smqueue'
  s.homepage = 'http://github.com/seanohalpin/smqueue'
  s.description = "Implements a simple protocol for using message queues, with adapters
  for ActiveMQ, Spread and stdio (for testing)."
  s.authors  = ["Sean O'Halpin"]
  s.files    = ["History.txt",
  "Manifest.txt",
  "README.txt",
  "Rakefile",
  "smqueue",
  "lib/rstomp.rb",
  "lib/smqueue.rb",
  "lib/smqueue/adapters/spread.rb",
  "lib/smqueue/adapters/stdio.rb",
  "lib/smqueue/adapters/stomp.rb"
  ]
  s.test_files = ["test/test_rstomp_connection.rb"]
  s.add_dependency("doodle", ["> 0.1.9"])
end
