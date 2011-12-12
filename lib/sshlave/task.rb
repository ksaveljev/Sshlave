module SSHlave
  class Task
    def initialize(options = {}, &block)
      @name = options.delete(:name)
      @options = options
      @block = block
      @commands = []
      build_commands
    end

    def build_commands
      self.instance_eval(&@block)
    end

    def run(command, options = {})
      if command.class == Symbol
        #@commands << options.merge()
      else
        @commands << options.merge({command: command, type: :remote, from: @name})
      end
    end

    def local(command, options = {})
      if command.class == Symbol
        #@commands << options.merge()
      else
        @commands << options.merge({command: command, type: :local, from: @name})
      end
    end
  end
end
