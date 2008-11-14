smqueue
    by Sean O'Halpin
    http://github.com/seanohalpin/smqueue

== DESCRIPTION:

Implements a simple protocol for using message queues, with adapters
for ActiveMQ, Spread and stdio (for testing).

This is a bare-bones release to share with my colleagues - apologies
for the lack of documentation and tests.

== FEATURES:

* simple to use
* designed primarily for pipeline processing
* compatible with Rails
* comes with a modified stomp.rb library (rstomp.rb)

== BUGS

* you need the ruby spread client installed - should remove this

== SYNOPSIS:

  require 'smqueue'
  config = YAML::load(config_file)
  input_queue = SMQueue(config[:input])
  output_queue = SMQueue(config[:output])
  queue.get do |msg|
     # do something with msg
     output_queue.put new_msg
  end

== REQUIREMENTS:

* depends on doodle
* you need access to an ActiveMQ message broker or Spread publisher
* development uses bones gem

== INSTALL:

* sudo gem install doodle smqueue

For development:

* sudo gem install bones

== LICENSE:

(The MIT License)

Copyright (c) 2008 Sean O'Halpin

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
