module SSHlave
  module TaskRunner
    extend self

    def execute(task)
      task.build_commands
    end
  end
end
