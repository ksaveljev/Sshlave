module SSHlave
  module TaskRunner
    class ConfigurationError < StandardError; end

    extend self

    def execute(task)
      task.build_commands

      if (task.servers.nil? or task.servers.empty? or task.servers.compact.empty?) and task.commands.any? { |c| c[:type] == :remote }
        raise ConfigurationError, "Task #{task.name.bold} includes remote commands, however no servers were defined for this task. Aborting.".red
      end
    end
  end
end
