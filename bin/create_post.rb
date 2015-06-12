#!/usr/bin/env ruby

POSTS_DIR = ENV['POSTS_DIR']

def header title
  timestamp = `date "+%Y-%m-%d %H:%M:%S"`.chomp
  contents = "---\n" +
             "layout: post\n" +
             "title: #{title}\n" +
             "date: #{timestamp}\n" +
             "categories:\n" +
             "---\n\n"
end

def post_file_path_with_title title
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

def title_from_filename filename
  index = filename.rindex(/\./)
  filename[0...index]
end

def title_from_file_path path
  filename = filename_from_path path
  title_from_filename filename
end

def contents_with_header_for_file_path path
  title = title_from_file_path path
  "#{header title}#{File.read(path)}"
end

def validate_input_file path
  exit_with_error "Markdown filename missing.\nUsage: create_post.rb <filename.markdown>" unless path
  exit_with_error "#{path} does not exist" unless File.file? path
  exit_with_error "Filename does not contain '.md'" unless path.rindex(/\.md/)
end

def dest_file_path_for_source_file_path path
  title = title_from_file_path path
  post_file_path_with_title title
end

def copy_from_source_to_dest_with_header(source_file_path, dest_file_path)
  contents = contents_with_header_for_file_path source_file_path
  File.write(dest_file_path, contents)
end

def git_commit_with_file_path path
  `cd #{POSTS_DIR}`
  `git add #{path}`
  `git commit -m "Add new post"`
end

def git_push
  `git push origin master`
end

def main
  exit_with_error "Environment variable 'POSTS_DIR' missing" unless POSTS_DIR

  source_file_path = ARGV.first
  validate_input_file source_file_path

  puts "Creating post..."
  dest_file_path = dest_file_path_for_source_file_path source_file_path
  copy_from_source_to_dest_with_header(source_file_path, dest_file_path)
  puts "Post Created !!!"
  
  puts "Adding your post to git repository..."
  git_commit_with_file_path dest_file_path

  puts "Pushing the commit..."
  git_push

  puts "Done !!!"
end

main if __FILE__ == $0
