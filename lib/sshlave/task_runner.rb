module SSHlave
  module TaskRunner
    class ConfigurationError < StandardError; end

    extend self

    def execute(task)
      task.build_commands

      if task.servers.empty? and task.commands.any? { |c| c[:type] == :remote }
        raise ConfigurationError, "Task '#{task.name.bold}' includes remote commands, however no servers were defined for this task. Aborting.".red
      end

      task.servers.each do |server|
        server = TaskManager.find_server(server)

        task.commands.each do |cmd|
          case cmd[:type]
          when :remote
            server.run(cmd[:command], cmd)
          when :local

          end
        end
      end
    end
  end
end
