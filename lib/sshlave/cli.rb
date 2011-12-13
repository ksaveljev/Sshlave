module SSHlave
  module CLI
    extend self

    def start(*args)
      SSHlave::TaskManager.load_tasks
      args.empty? ? SSHlave::TaskManager.run_task(:help) : SSHlave::TaskManager.run_task(*args)
    rescue
      puts "Sorry, '%s' was not found, see available tasks:".red % args.join(' ').bold
      puts
      SSHlave::TaskManager.run_task(:list)
    end
  end
end
