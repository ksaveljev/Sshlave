module SSHlave
  class Task
    attr_reader :name, :commands, :servers

    def initialize(options = {}, &block)
      @name = options.delete(:name)
      @options = options
      @block = block
      @commands = []
      @servers = options.delete(:servers)
    end

    def build_commands
      self.instance_eval(&@block)
    end

    def description
      @options[:desc].nil? ? "no description for this task" : @options[:desc]
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
