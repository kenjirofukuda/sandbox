#!/usr/bin/env ruby

require 'fileutils'

def process_file(target)
  # options = {preserve: true}
  unless File.exist? target
    STDERR.puts "File not found: #{target}"
    return
  end

  unless [".h", ".m", "mm"].any? { | ext | target.end_with? ext }
    STDERR.puts "File is not a objective-c file: #{target}"
    return
  end

  temp_file = "/tmp/#{$$}-#{File.basename(target)}"
  backup_file = "#{temp_file}.orig"
  FileUtils.cp target, backup_file
  File.open(temp_file, 'w') do |fo|
    first_line = ""
    joined_line = ""
    File.foreach(target) { |line|
      skip = false
      if /\s*(@(implementation|interface))\s*$/ =~ line
        first_line = Regexp.last_match[1]
        skip = true
      end
      unless first_line.empty?
        if /\s*([\w]+)\s*(\([\w]+\))\s*$/ =~ line
          class_part = Regexp.last_match[1]
          category_part = Regexp.last_match[2]
          joined_line = [first_line, class_part, category_part].join(" ")
          fo.puts joined_line
          joined_line = ""
          first_line = ""
          skip = true
        end
      end
      fo.puts line.rstrip unless skip
    }
  end
  FileUtils.cp temp_file, target
end

ARGV.each { |arg| process_file(arg) }
