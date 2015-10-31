#!/usr/bin/env ruby

require "pty"

@logfile = "/tmp/pgids"

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
        f.puts "child | pgid: #{Process.getpgid(Process.pid)}"
      end
    end
  end

  # The parent being tested will also report is PGID
  #
  loop do
    sleep 2

    File.open(@logfile, "w") do |f|
      f.puts "parent | pgid: #{Process.getpgid(Process.pid)}"
    end
  end
end

# The parent of the tests is still running too; it
# will tail the logfile so that we can see the results
#
PTY.spawn("tail -f #{@logfile}") do |r, _, _|
  r.each { |line| print line }
end
