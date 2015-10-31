#!/usr/bin/env ruby

require "pty"
require "rake"

@logfile = "/tmp/pgids"

FileUtils.touch(@logfile)

def get_child_info()
  Hash[*`ps -eo pid,ppid | grep #{Process.pid}`.scan(/\d+/).map{|x|x.to_i}].reject { |k,v| k == Process.pid }
end

# Fork off processes to test
#
fork do

  # The parent being tested forks off a child to test
  #
  fork do

    # The child process will report is PGID over and over to the logfile
    #
    loop do
      sleep 2

      File.open(@logfile, "w") do |f|
        f.puts "child | pid: #{Process.pid} | pgid: #{Process.getpgid(Process.pid)}"
      end
    end
  end

  # The parent being tested will also report is PGID
  #
  loop do
    sleep 2

    File.open(@logfile, "w") do |f|
      f.puts "parent | pid: #{Process.pid} | pgid: #{Process.getpgid(Process.pid)}"
    end
  end
end

# The parent of the tests is still running too; it
# will tail the logfile so that we can see the results
#
r, _, @pty_pid = PTY.spawn("tail -f #{@logfile}")

trap "INT" do
  get_child_info.keys.each do |pid|
    begin
      Process.kill("KILL", pid)
      Process.wait(pid)
    rescue Errno::ESRCH
    end
  end

  puts "Process | pid #{Process.pid} | ppid #{Process.ppid} | pgid #{Process.getpgid(Process.pid)}"

  exit
end

r.each { |line| print line }
