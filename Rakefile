# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "helpshift"
  gem.homepage = "http://github.com/wooga/helpshift.gem"
  gem.license = "MIT"
  gem.summary = %Q{Provide a wrapper for the helpshift.com API.}
  gem.description = %Q{Provide a wrapper for the helpshift.com API.}
  gem.email = "tobias.wermuth@wooga.com, stephan.lindauer@wooga.com"
  gem.authors = ["Tobias Wermuth, Stephan Lindauer"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

desc "Start a pry shell and load all gems"
task :shell do
 require 'pry'
 $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
 require_relative "lib/helpshift"
 Pry.editor = "emacs"
 Pry.start
end
