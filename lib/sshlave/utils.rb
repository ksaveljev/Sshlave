module SSHlave
  module Utils
    def log(msg, new_line = false)
      text += "\n" if new_line && msg[-1] != ?\n
      SSHLAVE_LOGGER.print msg
    end
  end
end
