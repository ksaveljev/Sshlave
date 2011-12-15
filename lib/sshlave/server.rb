module SSHlave
  class Server
    include SSHlave::Utils

    def initialize(options = {})
      @name = options.delete(:name)
      @user = options.delete(:user)
      @options = options
    end

    def log(msg, new_line = true)
      super(SSHLAVE_LOGGER_FORMAT % [@user, @name, msg], new_line)
    end
  end
end
