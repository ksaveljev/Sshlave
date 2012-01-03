module SSHlave
  class Task
    attr_reader :name, :namespace, :commands, :servers

    def initialize(options = {}, &block)
      @name = options.delete(:name)
      @namespace = options.delete(:namespace)
      @options = options
      @block = block
      @commands = []
      @servers = ([] << options.delete(:servers)).flatten.compact
    end

    def build_commands
      self.instance_eval(&@block)
    end

    def description
      @options[:desc].nil? ? "no description for this task" : @options[:desc]
    end

    def run(command, options = {})
      @commands << options.merge({command: command, type: :remote})
    end

    def local(command, options = {})
      @commands << options.merge({command: command, type: :local})
    end
  end
end
