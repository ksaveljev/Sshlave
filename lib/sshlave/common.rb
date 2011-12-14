desc "show version number"
task :version do
  #log "SSHlave version %s" % SSHlave::VERSION
end

desc "show list of available tasks"
task :list do
  formatted = TaskManager.tasks.map { |t| ["sshlave".bold + (" %s".blue % t.name), t.description] }
  formatted.each { |f| f[0].gsub!(/\s:/, ' ') }
  max = formatted.max { |a, b| a[0].size <=> b[0].size }[0].size
  puts formatted.map { |t, desc| "%s # %s" % [t.ljust(max+2), desc] }.join("\n")
end

desc "show help message"
task :help do
  TaskManager.run_task(:list)
end
