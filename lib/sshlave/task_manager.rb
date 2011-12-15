module SSHlave
  module TaskManager
    class TaskNotFound < StandardError; end
    class ServerNotFound < StandardError; end

    extend self

    def tasks
      @tasks ||= []
    end

    def servers
      @servers ||= {}
    end

    def desc(*args)
      @desc = args.shift
    end

    def load_tasks
      (Dir[File.join(SSHLAVE_PATH, "tasks/*.rake")].flatten <<
      File.expand_path('../common.rb', __FILE__)).each do |f|
        load_task(f)
      end
    end

    def load_task(path)
      instance_eval(File.read(path), __FILE__, __LINE__)
    end

    def server(name, host, user, options = {})
      servers[name] = Server.new(name, host, user, options)
    end

    def task(name, options = {}, &block)
      tasks.push(Task.new(options.merge({desc: @desc, name: name.to_s}), &block))
    ensure
      @desc = nil
    end

    def run_task(*task_to_run)
      task = find_task(task_to_run.shift)
      TaskRunner.execute(task)
    end

    def find_task(name)
      tasks.find { |t| t.name == name.to_s } || raise(TaskNotFound, 'Task "%s" not found' % name)
    end

    def find_server(name)
      servers[:name] || raise(ServerNotFound, 'Server "%s" not found' % name)
    end
  end
end
