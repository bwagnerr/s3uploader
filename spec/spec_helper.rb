RSpec.configure do |config|
  config.before(:all) { silence_output }
  config.after(:all) { enable_output }
end

def silence_output
  @orig_stderr = $stderr
  @orig_stdout = $stdout

  $stderr = File.new('/dev/null', 'w')
  $stdout = File.new('/dev/null', 'w')
end

def enable_output
  $stderr = @orig_stderr
  $stdout = @orig_stdout
  @orig_stderr = nil
  @orig_stdout = nil
end
