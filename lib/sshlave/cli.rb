module SSHlave
  module CLI
    extend self

    def start(*args)
      SSHlave::TaskManager.load_tasks
      args.empty? ? SSHlave::TaskManager.run_task(:help) : SSHlave::TaskManager.run_task(*args)
    end
  end
end
