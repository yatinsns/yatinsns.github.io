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

def exit_with_error text
  puts "Error: #{text}"
  exit 1
end

def main
  exit_with_error "Environment variable 'POSTS_DIR' missing" if POSTS_DIR.nil?

  source_filename = ARGV.first
  exit_with_error "Markdown filename missing.\nUsage: create_post.rb <filename.markdown>" if source_filename.nil?
  exit_with_error "#{source_filename} does not exist" unless File.file? source_filename

  index = source_filename.rindex(/\.markdown/)
  exit_with_error "Filename does not contain '.markdown'" if index.nil?

  title = source_filename[0...index]
  new_filename = filename title
  contents = "#{header title}#{File.read(source_filename)}"

  File.write(new_filename, contents)
end

main if __FILE__ == $0
