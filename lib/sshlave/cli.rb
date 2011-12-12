module SSHlave
  module CLI
    extend self

    def start(*args)
      SSHlave::TaskManager.load_tasks
    end
  end
end
