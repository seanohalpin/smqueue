# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  load 'tasks/setup.rb'
end

ensure_in_path 'lib'
require 'smqueue'

task :default => "test"

PROJ.name = 'smqueue'
PROJ.authors = "Sean O'Halpin"
PROJ.email = 'sean.ohalpin@gmail.com'
PROJ.url = 'http://github.com/seanohalpin/smqueue'
PROJ.version = SMQueue::VERSION
PROJ.rubyforge.name = 'metaphor'
PROJ.gem.dependencies << ["doodle", ">= 0.1.9"]

PROJ.spec.opts << '--color'

# EOF
