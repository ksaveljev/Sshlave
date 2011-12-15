require 'smart_colored/extend'

SSHLAVE_LOGGER = $stdout unless defined?(SSHLAVE_LOGGER)
# TODO: instead of ~ add current working directory
SSHLAVE_LOGGER_FORMAT = "%s".cyan + "@".yellow + "%s".red + " ~ ".yellow + "#".magenta + " %s" unless defined?(SSHLAVE_LOGGER_FORMAT)
SSHLAVE_PATH = ENV['SSHLAVE_PATH'] ||= File.expand_path("~/sshlave") unless defined?(SSHLAVE_PATH)

module SSHlave
  autoload :CLI,          'sshlave/cli.rb'
  autoload :Server,       'sshlave/server.rb'
  autoload :Task,         'sshlave/task.rb'
  autoload :TaskManager,  'sshlave/task_manager.rb'
  autoload :TaskRunner,   'sshlave/task_runner.rb'
  autoload :Utils,        'sshlave/utils.rb'
  autoload :VERSION,      'sshlave/version.rb'
end
