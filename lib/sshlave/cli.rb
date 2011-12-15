module SSHlave
  module CLI
    extend self

    def start(*args)
      SSHlave::TaskManager.load_tasks
      args.empty? ? SSHlave::TaskManager.run_task(:help) : SSHlave::TaskManager.run_task(*args)
    rescue SSHlave::TaskManager::TaskNotFound
      puts ("Sorry, '%s' was not found, see available tasks:" % args.join(' ').bold).red
      puts
      SSHlave::TaskManager.run_task(:list)
    rescue Exception => e
      $stderr << e << "\n"
    end
  end
end
