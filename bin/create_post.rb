#!/usr/bin/env ruby

POSTS_DIR = ENV['POSTS_DIR']

if POSTS_DIR.nil?
  puts "Error: Environment variable 'POSTS_DIR' missing"
  exit 1
end

source_filename = ARGV.first
dest_filename = `echo $(date "+%Y-%m-%d")"-#{ARGV.drop(1).join('-')}.markdown"`
dest_filename = "#{POSTS_DIR}/#{dest_filename.chomp}"
File.write(dest_filename, File.read(source_filename))
