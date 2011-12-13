require 'smart_colored/extend'

SSHLAVE_PATH = ENV['SSHLAVE_PATH'] ||= File.expand_path("~/sshlave") unless defined?(SSHLAVE_PATH)

module SSHlave
  autoload :CLI,          'sshlave/cli.rb'
  autoload :Server,       'sshlave/server.rb'
  autoload :Task,         'sshlave/task.rb'
  autoload :TaskManager,  'sshlave/task_manager.rb'
  autoload :TaskRunner,   'sshlave/task_runner.rb'
  autoload :VERSION,      'sshlave/version.rb'
end
