module SSHlave
  module CLI
    extend self

    def start(*args)
      SSHlave::TaskManager.load_tasks
      puts "load_tasks completed"
      puts args.empty? ? "empty" : "not empty"
      args.empty? ? SSHlave::TaskManager.run_task(:help) : SSHlave::TaskManager.run_task(*args)
    rescue
      puts ("Sorry, '%s' was not found, see available tasks:" % args.join(' ').bold).red
      puts
      SSHlave::TaskManager.run_task(:list)
    end
  end
end
