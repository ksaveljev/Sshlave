require 'net/ssh'

module SSHlave
  class Server
    include SSHlave::Utils

    attr_reader :state

    def initialize(name, host, user, options = {})
      @name, @host, @user, @options = name, host, user, options
      @request_pty, @hidden = true, false
      @state = :closed
    end

    def ssh
      @ssh ||= Net::SSH.start(@host, @user, @options)
    end

    def channel
      return @channel if @channel

      @state = :opening
      @channel = ssh.open_channel(&method(:open_succeeded))
      @channel.on_open_failed(&method(:open_failed))

      ssh.loop { opening? }

      @channel
    end

    def closed?
      state == :closed
    end

    def open?
      state == :open
    end

    def opening?
      !open? && !closed?
    end

    def open_succeeded(channel)
      @state = :pty
      @channel.request_pty(:modes => { Net::SSH::Connection::Term::ECHO => 0 }, &method(:pty_requested))
    end

    def open_failed(channel, code, description)
      @state = :closed
      raise "Crazy thing! Couldn't open channel for our ssh session"
    end

    def pty_requested(channel, success)
      @state = :shell
      raise "Crazy thing! Couldn't request pty for our ssh session" unless success
      @channel.send_channel_request("shell", &method(:shell_requested))
    end

    def shell_requested(channel, success)
      @state = :initializing
      raise "Crazy thing! Couldn't request shell for our ssh session" unless success
      @channel.on_data(&method(:look_for_initialization_done))
      @channel.send_data "export PS1=; echo #{separator} $?\n"
      p separator
    end

    def look_for_initialization_done(channel, data)
      if data.include?(separator)
        @state = :open
      end
    end

    def separator
      @separator ||= begin
        s = Digest::SHA1.hexdigest([ssh.object_id, object_id, Time.now.to_i, Time.now.usec, rand(0xFFFFFFFF)].join(":"))
        s << Digest::SHA1.hexdigest(s)
      end
    end

    def log(msg, new_line = true)
      super(SSHLAVE_LOGGER_FORMAT % [@user, @name, msg], new_line)
    end

    def run(cmd, options = {})
      options[:pty] = @request_pty unless options.has_key?(:pty)
      options[:hidden] = @hidden unless options.has_key?(:hidden)

      if options[:as]
        if options[:as] == 'root'
          cmd = "sudo #{cmd}"
        else
          cmd = "su #{options[:as]} -c '#{cmd.gsub("'", "'\\\\''")}'"
        end
      end

      log(cmd) unless options[:hidden]

      result = ""

      channel.exec cmd
      channel.on_data do |c, data|
        result << data

        unless options[:silent] || options[:hidden]
          SSHLAVE_LOGGER.print(data)
          SSHLAVE_LOGGER.flush
        end

        if options[:input]
          match = options[:match] || /password/i
          if data =~ match
            options[:input] += "\n" if options[:input][-1] != ?\n
            channel.send_data(options[:input])
            SSHLAVE_LOGGER.puts(options[:input]) unless options[:silent] || options[:hidden] || data =~ /password/i
          end
        end
      end

      ssh.loop

      result.chomp
    end
  end
end
