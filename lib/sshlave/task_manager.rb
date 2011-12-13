module SSHlave
  module TaskManager
    class NotFound < StandardError; end

    extend self

    def tasks
      @tasks ||= []
    end

    def desc(*args)
      @desc = args.shift
    end

    def load_tasks
      Dir[File.join(SSHLAVE_PATH, "tasks/*.rake")].each do |f|
        load_task(f)
      end
    end

    def load_task(path)
      instance_eval(File.read(path), __FILE__, __LINE__)
    end

    def server(name, options = {})
      # server = Server.new
    end

    def task(name, options = {}, &block)
      tasks.push(Task.new(name, options.merge({desc: @desc}), &block))
    ensure
      @desc = nil
    end

    def run_task(*task_to_run)
      task = find_task(args.shift)
    end

    def find_task(name)
      tasks.find { |t| t[:name] == name.to_sym } || raise(NotFound, 'Task "%s" not found' % name)
    end
  end
end
