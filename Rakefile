require 'logger'
require 'rake/testtask'

require './lib/geth'
require './lib/carbonvote'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Pull chain data from geth and process'
task :pull do
  stop = false

  Signal.trap('INT') { stop = true }
  Signal.trap('TERM') { stop = true }

  logger = Logger.new(STDOUT)
  node   = Geth.new(logger: logger)
  puller = Carbonvote::Puller.new(node: node, logger: logger)

  until stop
    puller.pull

    if puller.finished
      stop = true
    end
  end
end

task default: :test
