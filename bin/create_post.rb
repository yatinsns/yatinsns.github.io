#!/usr/bin/env ruby

POSTS_DIR = ENV['POSTS_DIR']

def header title
  timestamp = `date "+%Y-%m-%d %H:%M:%S"`
  contents = "---\n" +
             "layout: post\n" +
             "title: #{title}\n" +
             "date: #{timestamp.chomp}\n" +
             "categories: \n" +
             "---\n\n"
end

def filename title
  new_filename = `echo $(date "+%Y-%m-%d")"-#{title.gsub(' ', '-')}.markdown"`
  "#{POSTS_DIR}/#{new_filename.chomp}"
end

def main
  if POSTS_DIR.nil?
    puts "Error: Environment variable 'POSTS_DIR' missing"
    exit 1
  end

  source_filename = ARGV.first
  title = ARGV.drop(1).join(' ')
  new_filename = filename title

  contents = "#{header title}#{File.read(source_filename)}"
  File.write(new_filename, contents)
end

main if __FILE__ == $0
