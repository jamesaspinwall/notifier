namespace :test do
  desc "Test tests/lib/* code"
  Rails::TestTask.new(parsers: 'test:prepare') do |t|
    t.pattern = 'test/lib/**/*_test.rb'
  end
end

Rake::Task['test:run'].enhance ["test:parsers"]