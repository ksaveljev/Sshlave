SSHLAVE_PATH = ENV['SSHLAVE_PATH'] ||= File.expand_path("~/sshlave") unless defined?(SSHLAVE_PATH)

module SSHlave
  autoload :CLI,          'sshlave/cli.rb'
  autoload :TaskManager,  'sshlave/task_manager.rb'
  autoload :VERSION,      'sshlave/version.rb'
end
