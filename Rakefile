# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require_relative "lib/helpshiftgem"

desc "Start a pry shell and load all gems"
task :shell do
 require 'pry'
 $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
 Pry.editor = "emacs"
 Pry.start
end
