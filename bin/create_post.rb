#!/usr/bin/env ruby

POSTS_DIR = ENV['POSTS_DIR']

def contents
  timestamp = `date "+%Y-%m-%d %H:%M:%S"`
  contents = "---\n" +
             "layout: post\n" +
             "title: #{ARGV.join(' ')}\n" +
             "date: #{timestamp.chomp}\n" +
             "categories: \n" +
             "---\n\n"
end

def new_filename
  new_filename = `echo $(date "+%Y-%m-%d")"-#{ARGV.join('-')}.markdown"`
  "#{POSTS_DIR}/#{new_filename.chomp}"
end

def main
  if POSTS_DIR.nil?
    puts "Error: Environment variable 'POSTS_DIR' missing"
    exit 1
  end
  File.write(new_filename, contents)
end

main if __FILE__ == $0
