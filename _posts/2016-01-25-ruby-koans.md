---
layout: post
title: Ruby Koans
date: 2016-01-25 15:59:56
categories:
---


[RubyKoans](http://rubykoans.com) is an excellant approach to learn the Ruby language, syntax, structure, and some common functions and libraries. This also teaches you a testing culture. This requires tests to be fixed in order to progress.

My solutions are available [here](https://github.com/yatinsns/ruby-koans).



##Development Tweaks


### Real time updates

To check the solution, one has to run `rake` command everytime to know progress status. Smells like there is a need for automation.

I used [kicker](https://github.com/alloy/kicker) which is a lean, agnostic, flexible file-change watcher using OS X FSEvents.

You may add this simple `.kick` file to the koans project.
	
	process do |files|
  		execute("rake")
	end
	
To start,
	
	$ kick
	
Now whenever you modify any test and save the file, kicker will show you the current status.

### Git

To share solutions with everyone, I used git and pushed solutions to [Github repo](https://github.com/yatinsns/ruby-koans).

#### Prefill commit message


This project saves all the current progress in `.path_progress` file.
Sample file:

	0,1,2,2,3,3,4,4,5,5,5,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,9,9,9,9,10,10,10,10,10,10,11,11,11,12,12,12,13,13,13,13,13,13,14,14
	
Whenever a koan is finished, koan number is automatically appended to `.path_progress`.

Now trick is to prefill `git commit` message with the current progress. I created this `prepare-commit-msg` hook to solve this problem.

	#!/bin/sh

	commitMessage=$(./`git rev-parse --git-dir`/get-progress)
	echo "Finish koan $commitMessage\n $(cat $1)" > $1
	

This hook uses another script `get-progress` which prints the current progress(i.e. koan number).

	#!/usr/bin/env ruby

	PROGRESS_FILE_NAME = '.path_progress'

	contents = []
	if File.exists?(PROGRESS_FILE_NAME)
  		File.open(PROGRESS_FILE_NAME,'r') do |f|
    		contents = f.read.to_s.gsub(/\s/,'').split(',')
  		end
	end

	print contents.last
	
### Duplicates in .path_progress

Everytime `rake` is run, current progress (i.e. koan number) is added to `.path_progress` which leads to unnecessary file changes. This creates further problems when `.path_progress` is added to git repo. 

Time to fix `neo.rb`. Add following code to `add_progress` method.

	def add_progress(prog)
		@_contents = progress
		# return if already added to progress
		return if  prog.to_i == progress.last.to_i

