#!/usr/bin/env ruby

POSTS_DIR = ENV['POSTS_DIR']

def header title
  timestamp = `date "+%Y-%m-%d %H:%M:%S"`.chomp
  contents = "---\n" +
             "layout: post\n" +
             "title: #{title}\n" +
             "date: #{timestamp}\n" +
             "categories: \n" +
             "---\n\n"
end

def filename title
  new_filename = `echo $(date "+%Y-%m-%d")"-#{title.gsub(' ', '-')}.md"`
  "#{POSTS_DIR}/#{new_filename.chomp}"
end

def exit_with_error text
  puts "Error: #{text}"
  exit 1
end

def filename_from_path path
  last_slash_index = path.rindex(/\//)
  last_slash_index ? path[(last_slash_index+1)..-1] : path
end

def title_from_filename name
  index = name.rindex(/\./)
  name[0...index]
end

def main
  exit_with_error "Environment variable 'POSTS_DIR' missing" unless POSTS_DIR

  source_file_path = ARGV.first
  exit_with_error "Markdown filename missing.\nUsage: create_post.rb <filename.markdown>" unless source_file_path
  exit_with_error "#{source_file_path} does not exist" unless File.file? source_file_path

  index = source_file_path.rindex(/\.md/)
  exit_with_error "Filename does not contain '.md'" unless index

  puts "Creating post..."  

  source_filename = filename_from_path source_file_path
  title = title_from_filename source_filename 
  new_filename = filename title

  contents = "#{header title}#{File.read(source_file_path)}"

  File.write(new_filename, contents)
  puts "Post Created !!!"
  
  puts "Adding your post to git repository..."
  `cd #{POSTS_DIR}`
  `git add #{new_filename}`

  puts "Creating commit..."
  `git commit -m "Add post #{source_filename}"`

  puts "Pushing commit..."
  `git push origin master`

  puts "Done !!!"
end

main if __FILE__ == $0
