require "java"
require "rubygems"
require "bundler/setup"

current_path = File.dirname(__FILE__)

# Load all JAR files in vendor/jars
Dir[File.join(current_path,'vendor','jars','*.jar')].each do |file|
  puts file
  require file
end

# Require all files in lib
Dir[File.join(current_path,'lib','*.rb')].each do |file|
  puts file
  require file
end



