require "java"
require "rubygems"
require "bundler/setup"

current_path = File.expand_path(File.dirname(__FILE__))

# Load all JAR files in vendor/jars
Dir[File.join(current_path,'..','vendor','jars','**','*.jar')].each do |file|
  # puts file
  require file
end

# Require all files in lib
Dir[File.join(current_path,'fptools','**','*.rb')].each do |file|
  # puts file
  require file
end

module Fptools
  VERSION = '0.1'
end

