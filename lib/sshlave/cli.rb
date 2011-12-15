module SSHlave
  module CLI
    extend self

    def start(*args)
      SSHlave::TaskManager.load_tasks
      args.empty? ? SSHlave::TaskManager.run_task(:help) : SSHlave::TaskManager.run_task(*args)
    rescue SSHlave::TaskManager::NotFound
      puts ("Sorry, '%s' was not found, see available tasks:" % args.join(' ').bold).red
      puts
      SSHlave::TaskManager.run_task(:list)
    rescue SSHlave::TaskRunner::ConfigurationError => e
      $stderr << e << "\n"
    end
  end
end
