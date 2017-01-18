require 'logger'
require 'rake/testtask'

require './lib/geth'
require './lib/poller'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :poll do
  stop = false

  Signal.trap('INT') { stop = true }
  Signal.trap('TERM') { stop = true }

  logger = Logger.new(STDOUT)
  node   = Geth.new(logger: logger)
  puller = Puller.new(node: node, logger: logger)

  until stop
    puller.pull
  end
end

task default: :test
