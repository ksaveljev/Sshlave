module SSHlave
  module TaskManager
    extend self

    def tasks
      @tasks ||= {}
    end

    def load_tasks
      Dir[File.join(SSHLAVE_PATH, "tasks/*.rake")].each do |f|
        puts "loading task " + f.to_s
        load_task(f)
      end
    end

    def load_task(path)
      instance_eval(File.read(path), __FILE__, __LINE__)
    end

    def server(name, options = {})
      # server = Server.new
      puts "server definition added"
    end

    def task(name, options = {}, &block)
      # t = Task.new
      puts "task definition added"
    end
  end
end
