#!/usr/bin/env ruby

fork do
  loop do
    sleep 2

    File.open("/tmp/pids", "w") do |f|
      f.puts "child | pid: #{Process.pid} | pgid: #{Process.getpgid(Process.pid)}"
    end
  end
end

loop do
  sleep 2

  File.open("/tmp/pids", "w") do |f|
    f.puts "parent | pid: #{Process.pid} | pgid: #{Process.getpgid(Process.pid)}"
  end
end
