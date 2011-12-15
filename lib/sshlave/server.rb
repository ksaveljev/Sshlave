require 'net/ssh'

module SSHlave
  class Server
    include SSHlave::Utils

    def initialize(name, host, user, options = {})
      @name, @host, @user, @options = name, host, user, options
      @request_pty, @hidden = true, false
    end

    def ssh
      @ssh ||= Net::SSH.start(@host, @user, @options)
    end

    def channel
      @channel ||= ssh.open_channel
      channel.request_pty if options[:input] || options[:pty]
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

    def run2(cmd, options = {})
      options[:pty] = @request_pty unless options.has_key?(:pty)
      options[:hidden] = @hiden unless options.has_key?(:hidden)

      if options[:as]
        if options[:as] == 'root'
          cmd = "sudo #{cmd}"
        else
          cmd = "su #{options[:as]} -c '#{cmd.gsub("'", "'\\\\''")}'"
        end
      end

      log(cmd) unless options[:hidden]

      result = ""

      ssh.open_channel do |channel|
        channel.request_pty if options[:input] || options[:pty]
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
      end

      ssh.loop

      result.chomp
    end
  end
end
